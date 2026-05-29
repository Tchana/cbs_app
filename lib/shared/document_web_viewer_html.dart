/// Builds HTML shown inside the in-app WebView for any remote file URL.
String buildDocumentViewerHtml(String fileUrl) {
  final safeUrl = _escapeHtml(fileUrl);
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0" />
  <style>
    html, body { margin: 0; padding: 0; height: 100%; background: #111; }
    iframe { border: 0; width: 100%; height: 100%; }
  </style>
</head>
<body>
  <iframe src="$safeUrl" allowfullscreen title="document"></iframe>
</body>
</html>
''';
}

/// Google Docs embedded viewer — fallback for Office documents when direct view fails.
String buildGoogleDocsViewerHtml(String fileUrl) {
  final encoded = Uri.encodeComponent(fileUrl);
  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <style>
    html, body { margin: 0; padding: 0; height: 100%; background: #111; }
    iframe { border: 0; width: 100%; height: 100%; }
  </style>
</head>
<body>
  <iframe src="https://docs.google.com/gview?embedded=true&url=$encoded" allowfullscreen></iframe>
</body>
</html>
''';
}

String _escapeHtml(String value) {
  return value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
