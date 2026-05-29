import 'dart:convert';

import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/book_reading_progress_service.dart';
import 'package:center_for_biblical_studies/shared/document_pdf_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/document_web_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DocumentViewerScreen extends StatefulWidget {
  const DocumentViewerScreen({
    super.key,
    required this.url,
    this.title,
    this.bookId,
  });

  final String url;
  final String? title;
  final String? bookId;

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  late final WebViewController _webController;
  final BookReadingProgressService _progressService = BookReadingProgressService();
  bool _loading = true;
  String? _errorMessage;
  int _viewerAttempt = 0;
  int _displayPage = 0;
  int _displayPages = 0;

  bool get _isPdf => remoteFileKindFromUrl(widget.url) == RemoteFileKind.pdf;

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

    if (_trackBookPages) {
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
          if (!mounted || _viewerAttempt >= 2) {
            if (mounted) {
              setState(() {
                _loading = false;
                _errorMessage = error.description;
              });
            }
            return;
          }
          _loadFallbackViewer();
        },
      ),
    );
  }

  void _onReadingProgressMessage(String raw) {
    if (!_trackBookPages) return;
    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final page = (data['page'] as num?)?.toInt() ?? 0;
      final pages = (data['pages'] as num?)?.toInt() ?? 0;
      if (page <= 0 || pages <= 0) return;

      _progressService.recordPageProgress(
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

  Future<void> _loadPrimaryViewer() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _viewerAttempt = 0;
    });

    if (_isPdf) {
      await _loadPdfJsViewer();
      return;
    }

    if (remoteFileUrlNeedsDocsViewer(widget.url)) {
      _loadDocsViewer();
      return;
    }

    _viewerAttempt = 1;
    _webController.loadHtmlString(
      buildDocumentViewerHtml(widget.url),
      baseUrl: _baseUrlFor(widget.url),
    );
  }

  Future<void> _loadPdfJsViewer() async {
    var startPage = 1;
    if (_trackBookPages) {
      await _progressService.ensureStarted(widget.bookId);
      startPage = await _progressService.getResumePage(widget.bookId);
    }

    _viewerAttempt = 1;
    _webController.loadHtmlString(
      buildPdfJsViewerHtml(widget.url, startPage: startPage),
      baseUrl: 'https://cdnjs.cloudflare.com',
    );
  }

  void _loadDocsViewer() {
    setState(() => _viewerAttempt = 1);
    _webController.loadHtmlString(
      buildGoogleDocsViewerHtml(widget.url),
      baseUrl: 'https://docs.google.com',
    );
  }

  void _loadFallbackViewer() {
    if (_viewerAttempt >= 2) return;
    setState(() {
      _loading = true;
      _viewerAttempt = 2;
    });
    if (_isPdf) {
      _webController.loadHtmlString(
        buildGoogleDocsViewerHtml(widget.url),
        baseUrl: 'https://docs.google.com',
      );
    } else {
      _loadDocsViewer();
    }
  }

  String? _baseUrlFor(String fileUrl) {
    final uri = Uri.tryParse(fileUrl);
    if (uri == null || uri.host.isEmpty) return null;
    return '${uri.scheme}://${uri.host}';
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.tryParse(widget.url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _appBarTitle(AppLocalizations l10n) {
    if ((widget.title ?? '').trim().isNotEmpty) return widget.title!.trim();
    return l10n.documentViewer;
  }

  String? _pageSubtitle() {
    if (_displayPage <= 0 || _displayPages <= 0) return null;
    return '$_displayPage / $_displayPages';
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final pageSubtitle = _pageSubtitle();

    return Scaffold(
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
