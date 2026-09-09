import 'dart:io';
import 'dart:typed_data';

Future<Uint8List?> readLocalUriBytes(String uriOrPath) async {
  final trimmed = uriOrPath.trim();
  if (trimmed.startsWith('file://')) {
    return File.fromUri(Uri.parse(trimmed)).readAsBytes();
  }
  final file = File(trimmed);
  if (await file.exists()) {
    return file.readAsBytes();
  }
  return null;
}

Future<Uint8List?> readCachedPdfFileBytes({
  required String? pdfHtmlBaseUrl,
  required String relativeUrl,
}) async {
  final base = pdfHtmlBaseUrl?.trim();
  if (base == null || base.isEmpty) return null;
  try {
    final dirUri = Uri.parse(base.endsWith('/') ? base : '$base/');
    final file = File.fromUri(dirUri.resolve(relativeUrl));
    if (await file.exists()) {
      return file.readAsBytes();
    }
  } catch (_) {}
  return null;
}
