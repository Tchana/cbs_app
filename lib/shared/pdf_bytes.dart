import 'dart:typed_data';

/// Returns true when [bytes] begin with the PDF magic header `%PDF`.
bool isPdfBytes(List<int> bytes) {
  return bytes.length >= 4 &&
      bytes[0] == 0x25 &&
      bytes[1] == 0x50 &&
      bytes[2] == 0x44 &&
      bytes[3] == 0x46;
}

/// Maximum PDF size embedded as base64 in WebView HTML (~10 MB file).
const int maxPdfBase64Bytes = 10 * 1024 * 1024;

Uint8List? tryDecodePdfBytes(List<int>? bytes) {
  if (bytes == null || bytes.isEmpty || !isPdfBytes(bytes)) return null;
  return Uint8List.fromList(bytes);
}
