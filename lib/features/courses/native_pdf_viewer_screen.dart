import 'dart:io';

import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/book_file_cache_service.dart';
import 'package:center_for_biblical_studies/services/book_reading_progress_service.dart';
import 'package:center_for_biblical_studies/shared/pdf_bytes.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// Native platform PDF viewer (Android PdfRenderer / iOS PDFKit via flutter_pdfview).
///
/// Avoids pdfrx/pdfium GitHub downloads at build time.
class NativePdfViewerScreen extends StatefulWidget {
  const NativePdfViewerScreen({
    super.key,
    required this.url,
    this.title,
    this.bookId,
    this.originalRemoteUrl,
    this.pdfHtmlBaseUrl,
  });

  final String url;
  final String? title;
  final String? bookId;

  /// Original remote URL when [url] is a cached/local path.
  final String? originalRemoteUrl;

  /// `file://` directory when [url] is a relative cached file name.
  final String? pdfHtmlBaseUrl;

  @override
  State<NativePdfViewerScreen> createState() => _NativePdfViewerScreenState();
}

class _NativePdfViewerScreenState extends State<NativePdfViewerScreen> {
  final BookReadingProgressService _progressService =
      BookReadingProgressService();

  bool _loading = true;
  String? _errorMessage;
  String? _localPath;
  int _initialPage = 1;
  int _displayPage = 0;
  int _displayPages = 0;
  int _loadGeneration = 0;
  PDFViewController? _pdfController;

  bool get _trackBookPages {
    final id = widget.bookId?.trim();
    return id != null && id.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _prepareDocument();
  }

  Future<void> _prepareDocument() async {
    final gen = ++_loadGeneration;
    setState(() {
      _loading = true;
      _errorMessage = null;
      _localPath = null;
      _pdfController = null;
    });

    try {
      if (_trackBookPages) {
        await _progressService.markLastOpened(widget.bookId);
        _initialPage = await _progressService.getResumePage(widget.bookId);
      } else {
        _initialPage = 1;
      }

      final local = await _resolveLocalPdfPath();
      if (!mounted || gen != _loadGeneration) return;

      if (local != null) {
        setState(() {
          _localPath = local;
          _loading = false;
        });
        return;
      }

      final networkUrl = await _resolveNetworkUrl();
      if (!mounted || gen != _loadGeneration) return;

      final downloaded = await _downloadToTemp(networkUrl);
      if (!mounted || gen != _loadGeneration) return;

      if (downloaded == null) {
        final l10n =
            AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
        setState(() {
          _loading = false;
          _errorMessage = l10n.pdfLoadError;
        });
        return;
      }

      setState(() {
        _localPath = downloaded;
        _loading = false;
      });
    } catch (_) {
      if (!mounted || gen != _loadGeneration) return;
      final l10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      setState(() {
        _loading = false;
        _errorMessage = l10n.pdfLoadError;
      });
    }
  }

  Future<String?> _resolveLocalPdfPath() async {
    final base = widget.pdfHtmlBaseUrl?.trim();
    final current = widget.url.trim();

    if (base != null &&
        base.isNotEmpty &&
        !current.startsWith('http') &&
        !current.startsWith('file://')) {
      try {
        final dirUri = Uri.parse(base.endsWith('/') ? base : '$base/');
        final file = File.fromUri(dirUri.resolve(current));
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          if (tryDecodePdfBytes(bytes) != null) return file.path;
        }
      } catch (_) {}
    }

    if (current.startsWith('file://')) {
      try {
        final file = File.fromUri(Uri.parse(current));
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          if (tryDecodePdfBytes(bytes) != null) return file.path;
        }
      } catch (_) {}
    }

    if (!current.contains('://') && current.contains(RegExp(r'[\\/]'))) {
      final file = File(current);
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        if (tryDecodePdfBytes(bytes) != null) return file.path;
      }
    }

    final bookId = widget.bookId?.trim() ?? '';
    final original = (widget.originalRemoteUrl ?? '').trim();
    if (bookId.isNotEmpty && original.isNotEmpty) {
      final cache = BookFileCacheService();
      final cached = await cache.getCachedFile(bookId, original);
      if (cached != null && await cached.exists()) {
        final bytes = await cached.readAsBytes();
        if (tryDecodePdfBytes(bytes) != null) return cached.path;
      }
    }

    return null;
  }

  Future<String> _resolveNetworkUrl() async {
    final original = (widget.originalRemoteUrl ?? '').trim();
    if (original.isNotEmpty) {
      return resolveStorageViewUrl(original);
    }
    final current = widget.url.trim();
    if (current.startsWith('http')) {
      return resolveStorageViewUrl(current);
    }
    throw StateError('No network PDF URL');
  }

  Future<String?> _downloadToTemp(String url) async {
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          receiveTimeout: const Duration(minutes: 3),
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
        ),
      );
      final data = response.data;
      if (data == null || data.isEmpty) return null;
      final bytes = tryDecodePdfBytes(data);
      if (bytes == null) return null;

      final dir = await getTemporaryDirectory();
      final name =
          'cbs_pdf_${DateTime.now().millisecondsSinceEpoch}_${bytes.length}.pdf';
      final file = File('${dir.path}${Platform.pathSeparator}$name');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (_) {
      return null;
    }
  }

  Future<void> _onPageChanged(int? page, int? total) async {
    // flutter_pdfview pages are 0-based.
    final page1 = (page ?? 0) + 1;
    final pages = total ?? _displayPages;
    if (!mounted) return;
    setState(() {
      _displayPage = page1;
      if (pages > 0) _displayPages = pages;
    });
    if (!_trackBookPages || pages <= 0) return;
    await _progressService.recordPageProgress(
      bookId: widget.bookId,
      currentPage: page1,
      totalPages: pages,
    );
  }

  Future<void> _flushProgress() async {
    if (!_trackBookPages) return;
    var page = _displayPage;
    var pages = _displayPages;
    try {
      final current = await _pdfController?.getCurrentPage();
      final count = await _pdfController?.getPageCount();
      if (current != null) page = current + 1;
      if (count != null && count > 0) pages = count;
    } catch (_) {}
    if (page <= 0 || pages <= 0) return;
    await _progressService.recordPageProgress(
      bookId: widget.bookId,
      currentPage: page,
      totalPages: pages,
    );
  }

  Future<void> _openExternally() async {
    try {
      final url = await _resolveNetworkUrl();
      final uri = Uri.tryParse(url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      final uri = Uri.tryParse(widget.url);
      if (uri != null && await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  String _appBarTitle(AppLocalizations l10n) {
    if ((widget.title ?? '').trim().isNotEmpty) return widget.title!.trim();
    return l10n.documentViewer;
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final pageSubtitle = (_displayPage > 0 && _displayPages > 0)
        ? l10n.pageCounter(_displayPage, _displayPages)
        : null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _flushProgress();
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF111111),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_appBarTitle(l10n), overflow: TextOverflow.ellipsis),
              if (pageSubtitle != null)
                Text(
                  pageSubtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: l10n.refresh,
              onPressed: _prepareDocument,
              icon: const Icon(Icons.refresh_rounded),
            ),
            IconButton(
              tooltip: l10n.openInBrowser,
              onPressed: _openExternally,
              icon: const Icon(Icons.open_in_new_rounded),
            ),
          ],
        ),
        body: _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: Colors.white70,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _prepareDocument,
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (_loading || _localPath == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final startPage = (_initialPage - 1).clamp(0, 999999);

    return PDFView(
      key: ValueKey(_localPath),
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      fitPolicy: FitPolicy.BOTH,
      defaultPage: startPage,
      onRender: (pages) {
        if (!mounted) return;
        setState(() {
          _displayPages = pages ?? 0;
          if (_displayPage <= 0) {
            _displayPage = _initialPage.clamp(1, _displayPages > 0 ? _displayPages : _initialPage);
          }
        });
      },
      onViewCreated: (controller) {
        _pdfController = controller;
      },
      onPageChanged: _onPageChanged,
      onError: (_) {
        if (!mounted) return;
        setState(() => _errorMessage = l10n.pdfLoadError);
      },
      onPageError: (page, _) {
        if (!mounted) return;
        setState(() => _errorMessage = l10n.pdfLoadError);
      },
    );
  }
}
