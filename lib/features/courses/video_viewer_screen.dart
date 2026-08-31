import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:center_for_biblical_studies/shared/video_url_utils.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

class VideoViewerScreen extends StatefulWidget {
  const VideoViewerScreen({
    super.key,
    required this.url,
    this.title,
    this.originalUrl,
  });

  /// Resolved playback URL (signed when needed).
  final String url;

  /// Original remote URL for embed detection when [url] was signed.
  final String? originalUrl;

  final String? title;

  @override
  State<VideoViewerScreen> createState() => _VideoViewerScreenState();
}

class _VideoViewerScreenState extends State<VideoViewerScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _errorMessage;

  String get _sourceUrl => (widget.originalUrl ?? widget.url).trim();

  @override
  void initState() {
    super.initState();
    _initController();
    _loadVideo();
  }

  void _initController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black);

    final platform = _controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setMediaPlaybackRequiresUserGesture(false);
    }

    _controller.setNavigationDelegate(
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
          final l10n =
              AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
          setState(() {
            _loading = false;
            _errorMessage = l10n.fileLoadError;
          });
        },
      ),
    );
  }

  Future<void> _loadVideo() async {
    final playback = parseEmbeddableVideo(_sourceUrl);
    if (playback == null) {
      if (!mounted) return;
      final l10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      setState(() {
        _loading = false;
        _errorMessage = l10n.fileLoadError;
      });
      return;
    }

    final signed = await resolveStorageViewUrl(widget.url.trim());
    final html = playback.isDirectFile
        ? buildDirectVideoHtml(signed)
        : buildEmbedVideoHtml(playback.embedUrl!);

    await _controller.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final title = (widget.title ?? '').trim();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: isDark ? CbsColors.darkSurface : Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          title.isNotEmpty ? title : l10n.watchVideo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
            )
          : Stack(
              children: [
                WebViewWidget(controller: _controller),
                if (_loading)
                  const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
              ],
            ),
    );
  }
}
