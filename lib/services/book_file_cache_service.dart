import 'dart:convert';
import 'dart:io';

import 'package:center_for_biblical_studies/shared/pdf_bytes.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Distinguishes on-device cache folders (books vs course lessons).
enum RemoteFileCacheKind {
  book,
  lesson,
}

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

  static String _metaPrefix(RemoteFileCacheKind kind) =>
      '${kind.name}_file_cache_meta_';

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

  Future<bool> isCached(
    String cacheId,
    String remoteUrl, {
    RemoteFileCacheKind kind = RemoteFileCacheKind.book,
  }) async {
    final file = await _localFile(cacheId, remoteUrl, kind: kind);
    if (file == null || !await file.exists()) return false;
    final meta = await _readMeta(cacheId, kind: kind);
    if (meta?['remoteKey'] != stableRemoteKey(remoteUrl)) return false;
    if (_isPdfRemote(remoteUrl) && !await _fileLooksLikePdf(file)) return false;
    return true;
  }

  Future<void> invalidate(
    String cacheId, {
    RemoteFileCacheKind kind = RemoteFileCacheKind.book,
  }) async {
    final id = cacheId.trim();
    if (id.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_metaKey(id, kind: kind));
    try {
      final dir = await _cacheDirectory(id, kind: kind);
      if (await dir.exists()) {
        await dir.delete(recursive: true);
      }
    } catch (_) {}
  }

  Future<File?> getCachedFile(
    String cacheId,
    String remoteUrl, {
    RemoteFileCacheKind kind = RemoteFileCacheKind.book,
  }) async {
    if (!await isCached(cacheId, remoteUrl, kind: kind)) return null;
    return _localFile(cacheId, remoteUrl, kind: kind);
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
    RemoteFileCacheKind kind = RemoteFileCacheKind.book,
    void Function(int received, int total)? onReceiveProgress,
  }) async {
    final id = bookId.trim();
    final remote = remoteUrl.trim();
    if (id.isEmpty || remote.isEmpty) {
      final signed = await resolveStorageViewUrl(remote);
      return CachedBookView(viewerUrl: signed);
    }

    final remoteKey = stableRemoteKey(remote);
    final existing = await _localFile(id, remote, kind: kind);
    if (existing != null &&
        await existing.exists() &&
        (await _readMeta(id, kind: kind))?['remoteKey'] == remoteKey) {
      if (_isPdfRemote(remote) && !await _fileLooksLikePdf(existing)) {
        await invalidate(id, kind: kind);
      } else {
        return _viewForFile(existing, remote);
      }
    }

    final signed = await resolveStorageViewUrl(remote);
    final dir = await _cacheDirectory(id, kind: kind);
    await dir.create(recursive: true);

    final ext = extensionFromFileName(fileNameFromUrl(remote));
    final baseName = kind == RemoteFileCacheKind.lesson ? 'lesson' : 'book';
    final fileName = ext.isEmpty ? '$baseName.bin' : '$baseName.$ext';
    final outFile = File('${dir.path}/$fileName');

    await _dio.download(
      signed,
      outFile.path,
      onReceiveProgress: onReceiveProgress,
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
    }, kind: kind);

    return _viewForFile(outFile, remote);
  }

  CachedBookView _viewForFile(File file, String remoteUrl) {
    final ext = extensionFromFileName(fileNameFromUrl(remoteUrl));
    final isPdf =
        ext == 'pdf' || remoteFileKindFromUrl(remoteUrl) == RemoteFileKind.pdf;

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

  Future<Directory> _cacheDirectory(
    String cacheId, {
    required RemoteFileCacheKind kind,
  }) async {
    final root = await getApplicationDocumentsDirectory();
    var userPart = 'guest';
    try {
      final userId =
          (Supabase.instance.client.auth.currentUser?.id ?? '').trim();
      if (userId.isNotEmpty) userPart = userId;
    } catch (_) {}
    return Directory('${root.path}/${kind.name}_cache/$userPart/$cacheId');
  }

  Future<File?> _localFile(
    String cacheId,
    String remoteUrl, {
    required RemoteFileCacheKind kind,
  }) async {
    final meta = await _readMeta(cacheId, kind: kind);
    if (meta != null) {
      final path = (meta['path'] as String?)?.trim();
      if (path != null && path.isNotEmpty) {
        return File(path);
      }
    }

    final dir = await _cacheDirectory(cacheId, kind: kind);
    if (!await dir.exists()) return null;

    final ext = extensionFromFileName(fileNameFromUrl(remoteUrl));
    final baseName = kind == RemoteFileCacheKind.lesson ? 'lesson' : 'book';
    final candidate = File('${dir.path}/$baseName.$ext');
    if (await candidate.exists()) return candidate;

    final entries =
        await dir.list().where((e) => e is File).cast<File>().toList();
    return entries.isEmpty ? null : entries.first;
  }

  String _metaKey(String cacheId, {required RemoteFileCacheKind kind}) =>
      '${_metaPrefix(kind)}$cacheId';

  Future<Map<String, dynamic>?> _readMeta(
    String cacheId, {
    required RemoteFileCacheKind kind,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_metaKey(cacheId, kind: kind));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> _writeMeta(
    String cacheId,
    Map<String, dynamic> meta, {
    required RemoteFileCacheKind kind,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metaKey(cacheId, kind: kind), jsonEncode(meta));
  }
}
