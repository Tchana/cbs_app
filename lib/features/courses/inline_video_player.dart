import 'package:center_for_biblical_studies/core/platform/platform_capabilities.dart';
import 'package:center_for_biblical_studies/features/courses/web_video_iframe_stub.dart'
    if (dart.library.html) 'package:center_for_biblical_studies/features/courses/web_video_iframe_web.dart'
    as web_iframe;
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/shared/open_remote_file.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:center_for_biblical_studies/shared/video_url_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

/// In-place video player (YouTube / Vimeo / direct file) for course cards.
class InlineVideoPlayer extends StatefulWidget {
  const InlineVideoPlayer({
    super.key,
    required this.url,
    this.originalUrl,
    this.autoplay = true,
    this.onFullscreen,
    this.showControls = true,
  });

  final String url;
  final String? originalUrl;
  final bool autoplay;
  final VoidCallback? onFullscreen;
  final bool showControls;

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  WebViewController? _controller;
  String? _webEmbedUrl;
  bool _loading = true;
  String? _errorMessage;

  String get _sourceUrl => (widget.originalUrl ?? widget.url).trim();

  @override
  void initState() {
    super.initState();
    if (PlatformCapabilities.supportsHtmlIFrameEmbed) {
      _loadWebEmbed();
      return;
    }
    if (!PlatformCapabilities.supportsInAppWebView) {
      _openExternally();
      return;
    }
    _initController();
    _loadVideo();
  }

  Future<void> _loadWebEmbed() async {
    final playback = parseEmbeddableVideo(
      _sourceUrl,
      autoplay: widget.autoplay,
    );
    if (playback == null) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _errorMessage = AppLocalizations.of(context)?.fileLoadError ??
            'Could not load video';
      });
      return;
    }

    if (playback.isDirectFile) {
      final signed = await resolveStorageViewUrl(widget.url.trim());
      await launchExternalUrl(signed);
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }

    if (!mounted) return;
    setState(() {
      _webEmbedUrl = playback.embedUrl;
      _loading = false;
    });
  }

  Future<void> _openExternally() async {
    final signed = await resolveStorageViewUrl(widget.url.trim());
    await launchExternalUrl(signed);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _errorMessage = null;
    });
  }

  void _initController() {
    final controller = WebViewController();

    // webview_flutter_web does not implement these APIs.
    if (!kIsWeb) {
      controller
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.black);

      final platform = controller.platform;
      if (platform is AndroidWebViewController) {
        platform.setMediaPlaybackRequiresUserGesture(false);
      }

      controller.setNavigationDelegate(
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
            final l10n = AppLocalizations.of(context) ??
                AppLocalizations(const Locale('fr'));
            setState(() {
              _loading = false;
              _errorMessage = l10n.fileLoadError;
            });
          },
        ),
      );
    }

    _controller = controller;
  }

  Future<void> _loadVideo() async {
    final controller = _controller;
    if (controller == null) return;

    final playback = parseEmbeddableVideo(
      _sourceUrl,
      autoplay: widget.autoplay,
    );
    if (playback == null) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context) ??
          AppLocalizations(const Locale('fr'));
      setState(() {
        _loading = false;
        _errorMessage = l10n.fileLoadError;
      });
      return;
    }

    final signed = await resolveStorageViewUrl(widget.url.trim());
    if (!mounted) return;

    try {
      if (playback.isDirectFile) {
        await controller.loadHtmlString(
          buildDirectVideoHtml(signed, autoplay: widget.autoplay),
        );
      } else {
        final embedUrl = playback.embedUrl!;
        await controller.loadHtmlString(
          buildEmbedVideoHtml(embedUrl),
          baseUrl: embedPlayerBaseUrl(embedUrl),
        );
      }
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context) ??
          AppLocalizations(const Locale('fr'));
      setState(() {
        _loading = false;
        _errorMessage = l10n.fileLoadError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
          ),
        ),
      );
    }

    if (PlatformCapabilities.supportsHtmlIFrameEmbed &&
        _webEmbedUrl != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          web_iframe.buildWebVideoIFrame(
            viewType:
                'cbs-video-${_webEmbedUrl.hashCode}-${widget.url.hashCode}',
            embedUrl: _webEmbedUrl!,
          ),
          if (widget.showControls && widget.onFullscreen != null)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: IconButton(
                  tooltip: 'Fullscreen',
                  onPressed: widget.onFullscreen,
                  icon: const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    if (!PlatformCapabilities.supportsInAppWebView &&
        !PlatformCapabilities.supportsHtmlIFrameEmbed) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: TextButton.icon(
            onPressed: _openExternally,
            icon: const Icon(Icons.open_in_new_rounded, color: Colors.white),
            label: Text(
              AppLocalizations.of(context)?.openInBrowser ?? 'Open',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }

    final controller = _controller;
    return Stack(
      fit: StackFit.expand,
      children: [
        if (controller != null) WebViewWidget(controller: controller),
        if (_loading)
          const ColoredBox(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
        if (widget.showControls && widget.onFullscreen != null)
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: 'Fullscreen',
                onPressed: widget.onFullscreen,
                icon: const Icon(
                  Icons.fullscreen_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
