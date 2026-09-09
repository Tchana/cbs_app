import 'package:center_for_biblical_studies/features/courses/inline_video_player.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/material.dart';

class VideoViewerScreen extends StatelessWidget {
  const VideoViewerScreen({
    super.key,
    required this.url,
    this.title,
    this.originalUrl,
    this.autoplay = true,
  });

  /// Resolved playback URL (signed when needed).
  final String url;

  /// Original remote URL for embed detection when [url] was signed.
  final String? originalUrl;

  final String? title;
  final bool autoplay;

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleText = (title ?? '').trim();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: isDark ? CbsColors.darkSurface : Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          titleText.isNotEmpty ? titleText : l10n.watchVideo,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: InlineVideoPlayer(
        url: url,
        originalUrl: originalUrl,
        autoplay: autoplay,
        showControls: false,
      ),
    );
  }
}
