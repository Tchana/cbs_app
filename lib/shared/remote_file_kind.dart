import 'dart:typed_data';

enum RemoteFileKind {
  pdf,
  image,
  text,
  video,
  audio,
  link,
  slides,
  doc,
  external,
}

RemoteFileKind remoteFileKindFromResourceType(String? resourceType) {
  switch (resourceType?.trim().toLowerCase()) {
    case 'video':
      return RemoteFileKind.video;
    case 'audio':
      return RemoteFileKind.audio;
    case 'pdf':
      return RemoteFileKind.pdf;
    case 'doc':
      return RemoteFileKind.doc;
    case 'image':
      return RemoteFileKind.image;
    case 'link':
      return RemoteFileKind.link;
    case 'slides':
      return RemoteFileKind.slides;
    default:
      return RemoteFileKind.external;
  }
}

RemoteFileKind remoteFileKindFromUrl(String url) {
  final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
  final dot = path.lastIndexOf('.');
  if (dot == -1 || dot == path.length - 1) {
    return RemoteFileKind.external;
  }
  final ext = path.substring(dot + 1);

  if (ext == 'pdf') return RemoteFileKind.pdf;

  if (const {
    'mp4',
    'webm',
    'mov',
    'm4v',
    'mkv',
  }.contains(ext)) {
    return RemoteFileKind.video;
  }

  if (const {
    'mp3',
    'wav',
    'm4a',
    'ogg',
    'aac',
    'flac',
  }.contains(ext)) {
    return RemoteFileKind.audio;
  }

  if (const {
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'bmp',
    'heic',
    'heif',
  }.contains(ext)) {
    return RemoteFileKind.image;
  }

  if (const {
    'txt',
    'md',
    'csv',
    'json',
    'xml',
    'log',
    'html',
    'htm',
  }.contains(ext)) {
    return RemoteFileKind.text;
  }

  if (const {
    'ppt',
    'pptx',
    'pps',
    'ppsx',
    'odp',
  }.contains(ext)) {
    return RemoteFileKind.slides;
  }

  if (const {
    'doc',
    'docx',
    'docm',
    'dot',
    'dotx',
    'rtf',
    'odt',
  }.contains(ext)) {
    return RemoteFileKind.doc;
  }

  return RemoteFileKind.external;
}

bool remoteFileKindOpensExternally(RemoteFileKind kind) {
  switch (kind) {
    case RemoteFileKind.audio:
    case RemoteFileKind.link:
      return true;
    case RemoteFileKind.video:
    case RemoteFileKind.pdf:
    case RemoteFileKind.image:
    case RemoteFileKind.text:
    case RemoteFileKind.slides:
    case RemoteFileKind.doc:
    case RemoteFileKind.external:
      return false;
  }
}

RemoteFileKind resolveRemoteFileKind({
  required String url,
  String? resourceType,
}) {
  if (resourceType != null && resourceType.trim().isNotEmpty) {
    final fromType = remoteFileKindFromResourceType(resourceType);
    if (fromType != RemoteFileKind.external) return fromType;
  }
  return remoteFileKindFromUrl(url);
}

RemoteFileKind remoteFileKindFromBytes(Uint8List bytes, {RemoteFileKind? fallback}) {
  if (bytes.length >= 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46) {
    return RemoteFileKind.pdf;
  }
  if (bytes.length >= 3 &&
      bytes[0] == 0xFF &&
      bytes[1] == 0xD8 &&
      bytes[2] == 0xFF) {
    return RemoteFileKind.image;
  }
  if (bytes.length >= 8 &&
      bytes[0] == 0x89 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x4E &&
      bytes[3] == 0x47) {
    return RemoteFileKind.image;
  }
  if (bytes.length >= 6) {
    final head = String.fromCharCodes(bytes.take(6));
    if (head.startsWith('GIF87a') || head.startsWith('GIF89a')) {
      return RemoteFileKind.image;
    }
  }
  if (bytes.length >= 12 &&
      String.fromCharCodes(bytes.take(4)) == 'RIFF' &&
      String.fromCharCodes(bytes.sublist(8, 12)) == 'WEBP') {
    return RemoteFileKind.image;
  }
  return fallback ?? RemoteFileKind.external;
}

String fileNameFromUrl(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return 'document';
  final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
  if (segments.isEmpty) return 'document';
  final name = segments.last;
  return name.contains('.') ? name : '$name.bin';
}

String extensionFromFileName(String name) {
  final dot = name.lastIndexOf('.');
  if (dot <= 0 || dot == name.length - 1) return '';
  return name.substring(dot + 1).toLowerCase();
}

/// Word formats we can render with Mammoth and track scroll progress (.docx family).
bool remoteFileUrlIsTrackableWord(String url) {
  final ext = extensionFromFileName(fileNameFromUrl(url));
  return const {'docx', 'docm', 'dotx'}.contains(ext);
}

/// Office formats that should use the embedded Google Docs viewer in WebView.
bool remoteFileUrlNeedsDocsViewer(String url) {
  final ext = extensionFromFileName(fileNameFromUrl(url));
  return const {
    'doc',
    'docx',
    'docm',
    'dot',
    'dotx',
    'rtf',
    'odt',
    'ppt',
    'pptx',
    'pps',
    'ppsx',
    'xls',
    'xlsx',
    'xlsm',
    'ods',
    'odp',
  }.contains(ext);
}
