import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/book_file_cache_service.dart';
import 'package:center_for_biblical_studies/services/book_reading_progress_service.dart';
import 'package:center_for_biblical_studies/shared/pdf_bytes.dart';
import 'package:center_for_biblical_studies/shared/document_docx_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/document_pdf_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/document_web_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class DocumentViewerScreen extends StatefulWidget {
  const DocumentViewerScreen({
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

  /// Original library file URL (used for type detection when [url] is local).
  final String? originalRemoteUrl;

  /// `file://` directory base for offline PDF.js (`url` is a relative file name).
  final String? pdfHtmlBaseUrl;

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  late final WebViewController _webController;
  final BookReadingProgressService _progressService = BookReadingProgressService();
  bool _loading = true;
  String? _errorMessage;
  int _viewerAttempt = 0;
  int _pdfLoadAttempt = 0;
  int _displayPage = 0;
  int _displayPages = 0;
  Uint8List? _pdfBytes;

  String get _kindSourceUrl =>
      (widget.originalRemoteUrl ?? widget.url).trim();

  bool get _isPdf =>
      remoteFileKindFromUrl(_kindSourceUrl) == RemoteFileKind.pdf;

  bool get _isTrackableWord =>
      remoteFileUrlIsTrackableWord(_kindSourceUrl);

  bool get _supportsReadingProgressJs => _isPdf || _isTrackableWord;

  bool get _trackBookPages {
    final id = widget.bookId?.trim();
    return id != null && id.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _initWebController();
    _loadPrimaryViewer();
  }

  void _initWebController() {
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF111111));

    final platform = _webController.platform;
    if (platform is AndroidWebViewController) {
      platform.setAllowFileAccess(true);
    }

    if (_trackBookPages || _isPdf) {
      _webController.addJavaScriptChannel(
        'ReadingProgress',
        onMessageReceived: (message) => _onReadingProgressMessage(message.message),
      );
    }

    _webController.setNavigationDelegate(
      NavigationDelegate(
        onPageStarted: (_) {
          if (mounted) setState(() => _loading = true);
        },
        onPageFinished: (_) {
          if (mounted) setState(() => _loading = false);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame == false) return;
          if (!mounted) return;
          if (_isPdf) {
            _retryPdfWithNextStrategy();
            return;
          }
          if (_viewerAttempt < 2) {
            _loadFallbackViewer();
          } else {
            final l10n = _l10n(context);
            setState(() {
              _loading = false;
              _errorMessage = l10n.fileLoadError;
            });
          }
        },
      ),
    );
  }

  Future<void> _onReadingProgressMessage(String raw) async {
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final error = (data['error'] as String?)?.trim();
      if (error != null && error.isNotEmpty) {
        if (_isPdf && mounted) {
          _retryPdfWithNextStrategy();
        }
        return;
      }

      if (!_trackBookPages) return;

      final page = (data['page'] as num?)?.toInt() ?? 0;
      final pages = (data['pages'] as num?)?.toInt() ?? 0;
      if (page <= 0 || pages <= 0) return;

      await _progressService.recordPageProgress(
        bookId: widget.bookId,
        currentPage: page,
        totalPages: pages,
      );

      if (mounted) {
        setState(() {
          _displayPage = page;
          _displayPages = pages;
        });
      }
    } catch (_) {}
  }

  Future<void> _flushProgress() async {
    if (!_trackBookPages) return;

    var page = _displayPage;
    var pages = _displayPages;

    if (_supportsReadingProgressJs) {
      try {
        final flushFn = _isPdf ? 'flushProgress' : 'flushScrollProgress';
        final raw = await _webController.runJavaScriptReturningResult(
          '(function(){ $flushFn(); return JSON.stringify({page: pageNum, pages: pageCount}); })()',
        );
        final decoded = _decodeJsJson(raw);
        if (decoded != null) {
          page = (decoded['page'] as num?)?.toInt() ?? page;
          pages = (decoded['pages'] as num?)?.toInt() ?? pages;
        }
      } catch (_) {}
    }

    if (page <= 0 || pages <= 0) return;
    await _progressService.recordPageProgress(
      bookId: widget.bookId,
      currentPage: page,
      totalPages: pages,
    );
  }

  Map<String, dynamic>? _decodeJsJson(Object? raw) {
    if (raw == null) return null;
    try {
      var text = raw.toString();
      if (text.startsWith('"') && text.endsWith('"')) {
        text = jsonDecode(text) as String;
      }
      final decoded = jsonDecode(text);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return null;
  }

  Future<void> _loadPrimaryViewer() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _viewerAttempt = 0;
      _pdfLoadAttempt = 0;
    });

    if (_isPdf) {
      await _loadPdfJsViewer();
      return;
    }

    if (_isTrackableWord) {
      await _loadWordViewer();
      return;
    }

    if (remoteFileUrlNeedsDocsViewer(_kindSourceUrl)) {
      await _loadDocsViewer();
      return;
    }

    _viewerAttempt = 1;
    _webController.loadHtmlString(
      buildDocumentViewerHtml(widget.url),
      baseUrl: _baseUrlFor(widget.url),
    );
  }

  Future<void> _loadPdfJsViewer() async {
    if (_trackBookPages) {
      await _progressService.markLastOpened(widget.bookId);
    }
    _pdfLoadAttempt = 0;
    await _loadPdfWithCurrentStrategy();
  }

  AppLocalizations _l10n(BuildContext context) =>
      AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

  Future<void> _retryPdfWithNextStrategy() async {
    if (!mounted || _pdfLoadAttempt >= 2) {
      if (mounted) {
        final l10n = _l10n(context);
        setState(() {
          _loading = false;
          _errorMessage ??= l10n.pdfLoadError;
        });
      }
      return;
    }
    _pdfLoadAttempt++;
    await _loadPdfWithCurrentStrategy();
  }

  Future<void> _loadPdfWithCurrentStrategy() async {
    if (!mounted) return;

    var startPage = 1;
    if (_trackBookPages) {
      startPage = await _progressService.getResumePage(widget.bookId);
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
      _viewerAttempt = 1;
    });

    try {
      if (_pdfLoadAttempt == 0) {
        final bytes = _pdfBytes ?? await _fetchPdfBytes();
        _pdfBytes = bytes;
        if (bytes != null && bytes.length <= maxPdfBase64Bytes) {
          if (!mounted) return;
          final l10n = _l10n(context);
          _webController.loadHtmlString(
            buildPdfJsViewerHtml(
              pdfBase64: base64Encode(bytes),
              startPage: startPage,
              loadingLabel: l10n.viewerLoading,
              failedToLoadPdfPrefix: l10n.viewerFailedLoadPdf(''),
              pdfJsFailedMessage: l10n.viewerPdfJsFailed,
            ),
            baseUrl: 'https://cdnjs.cloudflare.com',
          );
          return;
        }
        _pdfLoadAttempt = 1;
      }

      if (_pdfLoadAttempt == 1) {
        final url = await _resolveNetworkPdfUrl();
        if (!mounted) return;
        final l10n = _l10n(context);
        _webController.loadHtmlString(
          buildPdfJsViewerHtml(
            fileUrl: url,
            startPage: startPage,
            loadingLabel: l10n.viewerLoading,
            failedToLoadPdfPrefix: l10n.viewerFailedLoadPdf(''),
            pdfJsFailedMessage: l10n.viewerPdfJsFailed,
          ),
          baseUrl: 'https://cdnjs.cloudflare.com',
        );
        return;
      }

      await _loadGoogleDocsPdfViewer();
    } catch (e) {
      await _retryPdfWithNextStrategy();
    }
  }

  Future<String> _resolveNetworkPdfUrl() async {
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

  Future<Uint8List?> _fetchPdfBytes() async {
    final cached = _cachedPdfFile();
    if (cached != null && await cached.exists()) {
      final bytes = await cached.readAsBytes();
      return tryDecodePdfBytes(bytes);
    }

    final bookId = widget.bookId?.trim() ?? '';
    final original = (widget.originalRemoteUrl ?? '').trim();
    if (bookId.isNotEmpty && original.isNotEmpty) {
      try {
        final cache = BookFileCacheService();
        await cache.invalidate(bookId);
        final view = await cache.getOrDownload(
          bookId: bookId,
          remoteUrl: original,
        );
        final file = await cache.getCachedFile(bookId, original);
        if (file != null) {
          return tryDecodePdfBytes(await file.readAsBytes());
        }
        if (view.viewerUrl.startsWith('http')) {
          final bytes = await _downloadPdfBytes(view.viewerUrl);
          return tryDecodePdfBytes(bytes);
        }
      } catch (_) {}
    }

    if (widget.url.trim().startsWith('http')) {
      final bytes = await _downloadPdfBytes(
        await resolveStorageViewUrl(widget.url.trim()),
      );
      return tryDecodePdfBytes(bytes);
    }

    return null;
  }

  File? _cachedPdfFile() {
    final base = widget.pdfHtmlBaseUrl?.trim();
    if (base == null || base.isEmpty) return null;
    try {
      final dirUri = Uri.parse(base.endsWith('/') ? base : '$base/');
      return File.fromUri(dirUri.resolve(widget.url));
    } catch (_) {
      return null;
    }
  }

  Future<List<int>> _downloadPdfBytes(String url) async {
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
    if (data == null || data.isEmpty) {
      throw StateError('Empty PDF download');
    }
    return data;
  }

  Future<void> _loadGoogleDocsPdfViewer() async {
    _viewerAttempt = 2;
    final url = await _resolveNetworkPdfUrl();
    if (!mounted) return;
    _webController.loadHtmlString(
      buildGoogleDocsViewerHtml(url),
      baseUrl: 'https://docs.google.com',
    );
  }

  Future<List<int>> _loadDocumentBytes() async {
    final trimmed = widget.url.trim();
    if (trimmed.startsWith('file://')) {
      return File.fromUri(Uri.parse(trimmed)).readAsBytes();
    }
    final response = await Dio().get<List<int>>(
      trimmed,
      options: Options(
        responseType: ResponseType.bytes,
        receiveTimeout: const Duration(minutes: 2),
      ),
    );
    final bytes = response.data;
    if (bytes == null || bytes.isEmpty) {
      throw StateError('Empty document');
    }
    return bytes;
  }

  Future<void> _loadWordViewer() async {
    var startSegment = 1;
    if (_trackBookPages) {
      await _progressService.markLastOpened(widget.bookId);
      startSegment = await _progressService.getResumePage(widget.bookId);
    }

    setState(() {
      _loading = true;
      _viewerAttempt = 1;
    });

    try {
      final bytes = await _loadDocumentBytes();
      if (!mounted) return;
      final l10n = _l10n(context);
      _webController.loadHtmlString(
        buildDocxViewerHtml(
          docxBase64: base64Encode(bytes),
          startSegment: startSegment,
          loadingLabel: l10n.viewerLoading,
          failedToLoadDocumentPrefix: l10n.viewerFailedLoadDocument(''),
        ),
        baseUrl: 'https://cdnjs.cloudflare.com',
      );
    } catch (_) {
      if (!mounted) return;
      _loadDocsViewer(markLastOpened: false);
    }
  }

  Future<void> _loadDocsViewer({bool markLastOpened = true}) async {
    if (markLastOpened && _trackBookPages) {
      await _progressService.markLastOpened(widget.bookId);
    }
    var docsUrl = widget.url.trim();
    if (docsUrl.startsWith('file://') &&
        (widget.originalRemoteUrl ?? '').trim().isNotEmpty) {
      docsUrl = await resolveStorageViewUrl(widget.originalRemoteUrl!.trim());
    } else if (!docsUrl.startsWith('http')) {
      docsUrl = await resolveStorageViewUrl(docsUrl);
    }
    if (!mounted) return;
    setState(() => _viewerAttempt = 1);
    _webController.loadHtmlString(
      buildGoogleDocsViewerHtml(docsUrl),
      baseUrl: 'https://docs.google.com',
    );
  }

  Future<void> _loadFallbackViewer() async {
    if (_viewerAttempt >= 2) return;
    if (_isPdf) {
      _pdfLoadAttempt = 2;
      await _loadGoogleDocsPdfViewer();
      return;
    }
    await _loadDocsViewer();
  }

  String? _baseUrlFor(String fileUrl) {
    final uri = Uri.tryParse(fileUrl);
    if (uri == null || uri.host.isEmpty) return null;
    return '${uri.scheme}://${uri.host}';
  }

  Future<void> _openInBrowser() async {
    if (_isPdf) {
      try {
        final url = await _resolveNetworkPdfUrl();
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      } catch (_) {}
    }
    final uri = Uri.tryParse(widget.url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _appBarTitle(AppLocalizations l10n) {
    if ((widget.title ?? '').trim().isNotEmpty) return widget.title!.trim();
    return l10n.documentViewer;
  }

  String? _pageSubtitle(AppLocalizations l10n) {
    if (_displayPage <= 0 || _displayPages <= 0) return null;
    return l10n.pageCounter(_displayPage, _displayPages);
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final pageSubtitle = _pageSubtitle(l10n);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _flushProgress();
        if (!context.mounted) return;
        Navigator.of(context).pop();
      },
      child: Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _appBarTitle(l10n),
              overflow: TextOverflow.ellipsis,
            ),
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
            onPressed: _loadPrimaryViewer,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            tooltip: l10n.openInBrowser,
            onPressed: _openInBrowser,
            icon: const Icon(Icons.open_in_new_rounded),
          ),
        ],
      ),
      body: _errorMessage != null
          ? _ErrorBody(
              message: _errorMessage!,
              retryLabel: l10n.retry,
              onRetry: _loadPrimaryViewer,
            )
          : Stack(
              children: [
                WebViewWidget(controller: _webController),
                if (_loading)
                  const ColoredBox(
                    color: Color(0xFF111111),
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      ),
    );
  }
}

/// Backward-compatible alias for PDF-only call sites.
class PdfViewerScreen extends StatelessWidget {
  const PdfViewerScreen({super.key, required this.pdfUrl});

  final String pdfUrl;

  @override
  Widget build(BuildContext context) {
    return DocumentViewerScreen(url: pdfUrl);
  }
}
