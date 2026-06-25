import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Disk + memory cached network image provider (e.g. for [CircleAvatar]).
ImageProvider? cachedRemoteImageProvider(String? url) {
  final trimmed = (url ?? '').trim();
  if (trimmed.isEmpty) return null;
  return CachedNetworkImageProvider(trimmed);
}

/// Cached network image widget with optional loading/error fallbacks.
class CachedRemoteImage extends StatelessWidget {
  const CachedRemoteImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.placeholder,
    this.error,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Alignment alignment;
  final Widget? placeholder;
  final Widget? error;

  @override
  Widget build(BuildContext context) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return error ?? const SizedBox.shrink();

    return CachedNetworkImage(
      imageUrl: trimmed,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: placeholder != null
          ? (_, __) => placeholder!
          : (_, __) => const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
      errorWidget: error != null ? (_, __, ___) => error! : null,
    );
  }
}
