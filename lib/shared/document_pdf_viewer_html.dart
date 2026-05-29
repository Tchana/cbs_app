/// PDF.js in-WebView viewer with page navigation and progress reporting to Flutter.
String buildPdfJsViewerHtml(
  String fileUrl, {
  int startPage = 1,
}) {
  final safeUrl = _escapeJsString(fileUrl);
  final page = startPage < 1 ? 1 : startPage;

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
  <style>
    * { box-sizing: border-box; }
    html, body { margin: 0; height: 100%; background: #111; color: #eee; font-family: sans-serif; }
  body { display: flex; flex-direction: column; }
    #toolbar {
      flex: 0 0 auto;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 8px;
      padding: 8px 12px;
      background: #1a1a1a;
      border-bottom: 1px solid #333;
    }
    #toolbar button {
      background: #4a3728;
      color: #fff;
      border: none;
      border-radius: 8px;
      padding: 10px 16px;
      font-size: 14px;
      min-width: 44px;
    }
    #toolbar button:disabled { opacity: 0.35; }
    #pageLabel { font-size: 14px; font-weight: 600; flex: 1; text-align: center; }
    #canvasWrap {
      flex: 1 1 auto;
      overflow: auto;
      display: flex;
      justify-content: center;
      align-items: flex-start;
      padding: 12px;
    }
    #pdfCanvas { max-width: 100%; height: auto; background: #fff; }
    #status { padding: 12px; text-align: center; color: #aaa; font-size: 13px; }
  </style>
</head>
<body>
  <div id="toolbar">
    <button type="button" id="prevBtn" onclick="prevPage()">&#9664;</button>
    <span id="pageLabel">…</span>
    <button type="button" id="nextBtn" onclick="nextPage()">&#9654;</button>
  </div>
  <div id="canvasWrap"><canvas id="pdfCanvas"></canvas></div>
  <div id="status">Loading…</div>
  <script>
    pdfjsLib.GlobalWorkerOptions.workerSrc =
      'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

  var pdfDoc = null;
  var pageNum = $page;
  var pageCount = 0;
  var rendering = false;

  function postProgress() {
    if (!pageCount) return;
    var payload = JSON.stringify({ page: pageNum, pages: pageCount });
    if (window.ReadingProgress && ReadingProgress.postMessage) {
      ReadingProgress.postMessage(payload);
    }
  }

  function updateToolbar() {
    document.getElementById('pageLabel').textContent = pageNum + ' / ' + pageCount;
    document.getElementById('prevBtn').disabled = pageNum <= 1;
    document.getElementById('nextBtn').disabled = pageNum >= pageCount;
  }

  function renderPage(num) {
    if (!pdfDoc || rendering) return;
    rendering = true;
    document.getElementById('status').textContent = '';
    pdfDoc.getPage(num).then(function(page) {
      var viewport = page.getViewport({ scale: 1.35 });
      var canvas = document.getElementById('pdfCanvas');
      var ctx = canvas.getContext('2d');
      canvas.height = viewport.height;
      canvas.width = viewport.width;
      return page.render({ canvasContext: ctx, viewport: viewport }).promise;
    }).then(function() {
      rendering = false;
      updateToolbar();
      postProgress();
    }).catch(function(err) {
      rendering = false;
      document.getElementById('status').textContent = 'Page error: ' + err;
    });
  }

  function prevPage() {
    if (pageNum <= 1) return;
    pageNum--;
    renderPage(pageNum);
  }

  function nextPage() {
    if (pageNum >= pageCount) return;
    pageNum++;
    renderPage(pageNum);
  }

  pdfjsLib.getDocument('$safeUrl').promise.then(function(pdf) {
    pdfDoc = pdf;
    pageCount = pdf.numPages;
    if (pageNum > pageCount) pageNum = pageCount;
    if (pageNum < 1) pageNum = 1;
    renderPage(pageNum);
  }).catch(function(err) {
    document.getElementById('status').textContent = 'Failed to load PDF: ' + err;
  });
  </script>
</body>
</html>
''';
}

String _escapeJsString(String value) {
  return value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r');
}
