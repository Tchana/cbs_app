import 'package:center_for_biblical_studies/shared/document_docx_viewer_html.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('remoteFileUrlIsTrackableWord matches docx family only', () {
    expect(
      remoteFileUrlIsTrackableWord('https://x.com/book.docx'),
      isTrue,
    );
    expect(
      remoteFileUrlIsTrackableWord('https://x.com/book.doc'),
      isFalse,
    );
    expect(
      remoteFileUrlIsTrackableWord('https://x.com/book.pdf'),
      isFalse,
    );
  });

  test('buildDocxViewerHtml embeds mammoth and progress channel', () {
    final html = buildDocxViewerHtml(docxBase64: 'dGVzdA==', startSegment: 42);
    expect(html, contains('mammoth'));
    expect(html, contains('ReadingProgress'));
    expect(html, contains('scrollTarget = 42'));
    expect(html, contains('pageCount = 100'));
  });
}
