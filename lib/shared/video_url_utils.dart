import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';

/// Whether a lesson resource should be treated as an in-app video.
bool isInAppVideoResource({
  required String url,
  String? resourceType,
}) {
  if (remoteFileKindFromResourceType(resourceType) == RemoteFileKind.video) {
    return true;
  }
  if (remoteFileKindFromUrl(url) == RemoteFileKind.video) {
    return true;
  }
  return parseEmbeddableVideo(url) != null;
}

class EmbeddableVideo {
  const EmbeddableVideo({
    required this.isDirectFile,
    this.directUrl,
    this.embedUrl,
  });

  final bool isDirectFile;
  final String? directUrl;
  final String? embedUrl;
}

EmbeddableVideo? parseEmbeddableVideo(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return null;

  final youtubeId = _extractYoutubeId(trimmed);
  if (youtubeId != null) {
    return EmbeddableVideo(
      isDirectFile: false,
      embedUrl:
          'https://www.youtube.com/embed/$youtubeId?playsinline=1&rel=0&modestbranding=1',
    );
  }

  final vimeoId = _extractVimeoId(trimmed);
  if (vimeoId != null) {
    return EmbeddableVideo(
      isDirectFile: false,
      embedUrl: 'https://player.vimeo.com/video/$vimeoId?playsinline=1',
    );
  }

  if (remoteFileKindFromUrl(trimmed) == RemoteFileKind.video) {
    return EmbeddableVideo(
      isDirectFile: true,
      directUrl: trimmed,
    );
  }

  return null;
}

String? _extractYoutubeId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  if (host == 'youtu.be') {
    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    return id.isNotEmpty ? id : null;
  }

  if (host.contains('youtube.com') || host.contains('youtube-nocookie.com')) {
    if (uri.pathSegments.contains('embed') && uri.pathSegments.length >= 2) {
      final idx = uri.pathSegments.indexOf('embed');
      return uri.pathSegments[idx + 1];
    }
    final watchId = uri.queryParameters['v'];
    if (watchId != null && watchId.isNotEmpty) return watchId;
    if (uri.pathSegments.contains('shorts') && uri.pathSegments.length >= 2) {
      final idx = uri.pathSegments.indexOf('shorts');
      return uri.pathSegments[idx + 1];
    }
  }

  return null;
}

String? _extractVimeoId(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return null;

  final host = uri.host.toLowerCase();
  if (!host.contains('vimeo.com')) return null;

  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.isEmpty) return null;

  if (segments.first == 'video' && segments.length >= 2) {
    return segments[1];
  }

  final last = segments.last;
  return RegExp(r'^\d+$').hasMatch(last) ? last : null;
}

String buildDirectVideoHtml(String videoUrl) {
  final safeUrl = _escapeHtml(videoUrl);
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: #000;
      overflow: hidden;
    }
    video {
      width: 100%;
      height: 100%;
      object-fit: contain;
      background: #000;
    }
  </style>
</head>
<body>
  <video controls playsinline webkit-playsinline preload="metadata" src="$safeUrl"></video>
</body>
</html>
''';
}

String buildEmbedVideoHtml(String embedUrl) {
  final safeUrl = _escapeHtml(embedUrl);
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background: #000;
      overflow: hidden;
    }
    iframe {
      border: 0;
      width: 100%;
      height: 100%;
      background: #000;
    }
  </style>
</head>
<body>
  <iframe
    src="$safeUrl"
    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
    allowfullscreen
    title="video"
  ></iframe>
</body>
</html>
''';
}

String _escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
}
