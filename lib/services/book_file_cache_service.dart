import 'dart:convert';
import 'dart:io';

import 'package:center_for_biblical_studies/shared/pdf_bytes.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Resolved local or remote path for opening a library book in the viewer.
class CachedBookView {
  const CachedBookView({
    required this.viewerUrl,
    this.pdfHtmlBaseUrl,
    this.isCached = false,
  });

  /// URL/path passed to the document viewer (network URL or relative PDF name).
  final String viewerUrl;

  /// When set, PDF.js loads [viewerUrl] relative to this base (local `file://` dir).
  final String? pdfHtmlBaseUrl;

  final bool isCached;
}

class BookFileCacheService {
  BookFileCacheService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;
  static const _metaPrefix = 'book_file_cache_meta_';

  /// Stable cache invalidation key (ignores signed-URL query tokens).
  static String stableRemoteKey(String remoteUrl) {
    final uri = Uri.tryParse(remoteUrl.trim());
    if (uri == null) return remoteUrl.trim();

    final parsed = parseSupabaseStorageObjectLocation(uri);
    if (parsed != null) {
      final (bucket, objectPath, _) = parsed;
      return '$bucket/$objectPath';
    }
    return uri.path.isNotEmpty ? uri.path : remoteUrl.trim();
  }

  Future<bool> isCached(String bookId, String remoteUrl) async {
    final file = await _localFile(bookId, remoteUrl);
    if (file == null || !await file.exists()) return false;
    final meta = await _readMeta(bookId);
    if (meta?['remoteKey'] != stableRemoteKey(remoteUrl)) return false;
    if (_isPdfRemote(remoteUrl) && !await _fileLooksLikePdf(file)) return false;
    return true;
  }

  Future<void> invalidate(String bookId) async {
    final id = bookId.trim();
    if (id.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_metaKey(id));
    try {
      final dir = await _bookDirectory(id);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {}
  }

  Future<File?> getCachedFile(String bookId, String remoteUrl) async {
    if (!await isCached(bookId, remoteUrl)) return null;
    return _localFile(bookId, remoteUrl);
  }

  bool _isPdfRemote(String remoteUrl) =>
      remoteFileKindFromUrl(remoteUrl) == RemoteFileKind.pdf;

  Future<bool> _fileLooksLikePdf(File file) async {
    if (!await file.exists()) return false;
    final length = await file.length();
    if (length < 4) return false;
    final header = await file.openRead(0, 4).first;
    return isPdfBytes(header);
  }

  /// Returns a local view when cached; otherwise downloads to device storage first.
  Future<CachedBookView> getOrDownload({
    required String bookId,
    required String remoteUrl,
  }) async {
    final id = bookId.trim();
    final remote = remoteUrl.trim();
    if (id.isEmpty || remote.isEmpty) {
      final signed = await resolveStorageViewUrl(remote);
      return CachedBookView(viewerUrl: signed);
    }

    final remoteKey = stableRemoteKey(remote);
    final existing = await _localFile(id, remote);
    if (existing != null &&
        await existing.exists() &&
        (await _readMeta(id))?['remoteKey'] == remoteKey) {
      if (_isPdfRemote(remote) && !await _fileLooksLikePdf(existing)) {
        await invalidate(id);
      } else {
        return _viewForFile(existing, remote);
      }
    }

    final signed = await resolveStorageViewUrl(remote);
    final dir = await _bookDirectory(id);
    await dir.create(recursive: true);

    final ext = extensionFromFileName(fileNameFromUrl(remote));
    final fileName = ext.isEmpty ? 'book.bin' : 'book.$ext';
    final outFile = File('${dir.path}/$fileName');

    await _dio.download(
      signed,
      outFile.path,
      options: Options(
        receiveTimeout: const Duration(minutes: 5),
        followRedirects: true,
        validateStatus: (status) => status != null && status < 400,
      ),
    );

    if (!await outFile.exists() || await outFile.length() == 0) {
      throw const FormatException('Downloaded book file is empty');
    }

    if (_isPdfRemote(remote) && !await _fileLooksLikePdf(outFile)) {
      await outFile.delete();
      throw const FormatException('Downloaded file is not a valid PDF');
    }

    await _writeMeta(id, {
      'remoteKey': remoteKey,
      'path': outFile.path,
      'cachedAtMs': DateTime.now().millisecondsSinceEpoch,
    });

    return _viewForFile(outFile, remote);
  }

  CachedBookView _viewForFile(File file, String remoteUrl) {
    final ext = extensionFromFileName(fileNameFromUrl(remoteUrl));
    final isPdf = ext == 'pdf' || remoteFileKindFromUrl(remoteUrl) == RemoteFileKind.pdf;

    if (isPdf) {
      final dir = file.parent;
      final baseUrl = 'file://${dir.path}/';
      return CachedBookView(
        viewerUrl: file.uri.pathSegments.last,
        pdfHtmlBaseUrl: baseUrl,
        isCached: true,
      );
    }

    return CachedBookView(
      viewerUrl: file.uri.toString(),
      isCached: true,
    );
  }

  Future<Directory> _bookDirectory(String bookId) async {
    final root = await getApplicationDocumentsDirectory();
    var userPart = 'guest';
    try {
      final userId =
          (Supabase.instance.client.auth.currentUser?.id ?? '').trim();
      if (userId.isNotEmpty) userPart = userId;
    } catch (_) {}
    return Directory('${root.path}/book_cache/$userPart/$bookId');
  }

  Future<File?> _localFile(String bookId, String remoteUrl) async {
    final meta = await _readMeta(bookId);
    if (meta != null) {
      final path = (meta['path'] as String?)?.trim();
      if (path != null && path.isNotEmpty) {
        return File(path);
      }
    }

    final dir = await _bookDirectory(bookId);
    if (!await dir.exists()) return null;

    final ext = extensionFromFileName(fileNameFromUrl(remoteUrl));
    final candidate = File('${dir.path}/book.$ext');
    if (await candidate.exists()) return candidate;

    final entries = await dir.list().where((e) => e is File).cast<File>().toList();
    return entries.isEmpty ? null : entries.first;
  }

  String _metaKey(String bookId) => '$_metaPrefix$bookId';

  Future<Map<String, dynamic>?> _readMeta(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metaKey(bookId));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> _writeMeta(String bookId, Map<String, dynamic> meta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metaKey(bookId), jsonEncode(meta));
  }
}
