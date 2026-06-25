/// Mammoth.js DOCX viewer with vertical scroll and progress reporting to Flutter.
///
/// Uses 100 virtual "pages" mapped to scroll position (same contract as PDF viewer).
String buildDocxViewerHtml({
  required String docxBase64,
  int startSegment = 1,
  String loadingLabel = 'Loading…',
  String failedToLoadDocumentPrefix = 'Failed to load document: ',
}) {
  final segment = startSegment < 1 ? 1 : (startSegment > 100 ? 100 : startSegment);
  // Base64 alphabet only — safe to embed in a JS string literal.
  final safeB64 = docxBase64.replaceAll("'", r"\'").replaceAll('\n', '');
  final safeLoading = _escapeJsString(loadingLabel);
  final safeFailedPrefix = _escapeJsString(failedToLoadDocumentPrefix);

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=yes" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mammoth/1.8.0/mammoth.browser.min.js"></script>
  <style>
    * { box-sizing: border-box; }
    html, body {
      margin: 0;
      height: 100%;
      background: #111;
      color: #eee;
      font-family: sans-serif;
      overflow: hidden;
    }
    body { display: flex; flex-direction: column; }
    #viewer {
      flex: 1 1 auto;
      overflow-x: hidden;
      overflow-y: auto;
      -webkit-overflow-scrolling: touch;
      padding: 12px 10px 24px;
    }
    #content {
      max-width: 720px;
      margin: 0 auto;
      padding: 16px 14px 32px;
      background: #fff;
      color: #1a1a1a;
      border-radius: 4px;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.35);
      line-height: 1.6;
      font-size: 17px;
      -webkit-font-smoothing: antialiased;
      text-rendering: optimizeLegibility;
    }
    #content img { max-width: 100%; height: auto; }
    #content table { max-width: 100%; border-collapse: collapse; }
    #content td, #content th { border: 1px solid #ccc; padding: 4px 8px; }
    #status {
      flex: 0 0 auto;
      padding: 10px 12px;
      text-align: center;
      color: #aaa;
      font-size: 13px;
      border-top: 1px solid #222;
    }
  </style>
</head>
<body>
  <div id="viewer"><div id="content"></div></div>
  <div id="status">$safeLoading</div>
  <script>
    var pageCount = 100;
    var pageNum = $segment;
    var scrollTarget = $segment;
    var scrollTimer = null;
    var lastPostedPage = 0;
    var viewer = document.getElementById('viewer');
    var docxBase64 = '$safeB64';

    function postProgress(force) {
      if (!pageCount) return;
      if (!force && pageNum === lastPostedPage) return;
      lastPostedPage = pageNum;
      var payload = JSON.stringify({ page: pageNum, pages: pageCount });
      if (window.ReadingProgress && ReadingProgress.postMessage) {
        ReadingProgress.postMessage(payload);
      }
    }

    function updateScrollFromViewer() {
      var max = viewer.scrollHeight - viewer.clientHeight;
      if (max <= 0) {
        pageNum = 1;
        return;
      }
      var ratio = viewer.scrollTop / max;
      pageNum = Math.max(1, Math.min(pageCount, Math.round(ratio * (pageCount - 1)) + 1));
    }

    viewer.addEventListener('scroll', function() {
      clearTimeout(scrollTimer);
      scrollTimer = setTimeout(function() {
        updateScrollFromViewer();
        postProgress(false);
      }, 120);
    }, { passive: true });

    function scrollToSegment(num) {
      var max = viewer.scrollHeight - viewer.clientHeight;
      if (max <= 0) {
        pageNum = num;
        postProgress(true);
        return;
      }
      var ratio = (num - 1) / (pageCount - 1);
      viewer.scrollTop = ratio * max;
      pageNum = num;
      postProgress(true);
    }

    function flushScrollProgress() {
      clearTimeout(scrollTimer);
      updateScrollFromViewer();
      postProgress(true);
    }

    document.addEventListener('visibilitychange', function() {
      if (document.visibilityState === 'hidden') flushScrollProgress();
    });
    window.addEventListener('pagehide', flushScrollProgress);

    function base64ToArrayBuffer(base64) {
      var binary = atob(base64);
      var len = binary.length;
      var bytes = new Uint8Array(len);
      for (var i = 0; i < len; i++) bytes[i] = binary.charCodeAt(i);
      return bytes.buffer;
    }

    mammoth.convertToHtml({ arrayBuffer: base64ToArrayBuffer(docxBase64) })
      .then(function(result) {
        document.getElementById('content').innerHTML = result.value;
        document.getElementById('status').textContent = '';
        requestAnimationFrame(function() {
          scrollToSegment(scrollTarget);
          updateScrollFromViewer();
        });
      })
      .catch(function(err) {
        document.getElementById('status').textContent = '$safeFailedPrefix' + err;
      });
  </script>
</body>
</html>
''';
}

String _escapeJsString(String value) {
  return value
      .replaceAll('\\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r');
}
