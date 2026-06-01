import 'package:center_for_biblical_studies/shared/document_pdf_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/pdf_bytes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isPdfBytes detects PDF header', () {
    expect(isPdfBytes([0x25, 0x50, 0x44, 0x46, 0x2D]), isTrue);
    expect(isPdfBytes([0x00, 0x50, 0x44, 0x46]), isFalse);
  });

  test('buildPdfJsViewerHtml supports embedded base64 data', () {
    final html = buildPdfJsViewerHtml(
      pdfBase64: 'JVBERi0=',
      startPage: 3,
    );
    expect(html, contains('getDocument({ data: arr })'));
    expect(html, contains('notifyError'));
    expect(html, contains('scrollTargetPage = 3'));
  });
}
