/// PDF.js in-WebView viewer with vertical scrolling and progress reporting to Flutter.
///
/// Renders each page at device pixel ratio (min 2×) so text stays sharp on high-DPI screens.
String buildPdfJsViewerHtml({
  int startPage = 1,
  String? fileUrl,
  String? pdfBase64,
  String loadingLabel = 'Loading…',
  String failedToLoadPdfPrefix = 'Failed to load PDF: ',
  String pdfJsFailedMessage = 'PDF.js failed to load',
}) {
  assert(
    fileUrl != null || pdfBase64 != null,
    'Provide fileUrl or pdfBase64',
  );

  final page = startPage < 1 ? 1 : startPage;
  final loadDocumentJs = pdfBase64 != null
      ? _jsLoadDocumentFromBase64(pdfBase64)
      : "pdfjsLib.getDocument({ url: '${_escapeJsString(fileUrl!)}', withCredentials: false })";
  final safeLoading = _escapeJsString(loadingLabel);
  final safeFailedPrefix = _escapeJsString(failedToLoadPdfPrefix);
  final safePdfJsFailed = _escapeJsString(pdfJsFailedMessage);

  return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes" />
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
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
      overflow-x: auto;
      overflow-y: auto;
      -webkit-overflow-scrolling: touch;
      padding: 12px 8px 24px;
    }
    .page-wrap {
      display: flex;
      justify-content: center;
      margin: 0 auto 14px;
      width: 100%;
    }
    .page-wrap canvas {
      display: block;
      /* Never CSS-downscale after render — that softens text */
      max-width: none !important;
      width: auto;
      height: auto;
      background: #fff;
      box-shadow: 0 2px 12px rgba(0, 0, 0, 0.35);
    }
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
  <div id="viewer"></div>
  <div id="status">$safeLoading</div>
  <script>
    pdfjsLib.GlobalWorkerOptions.workerSrc =
      'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';

    var pdfDoc = null;
    var pageNum = $page;
    var pageCount = 0;
    var scrollTargetPage = $page;
    var scrollTimer = null;
    var lastPostedPage = 0;
    var renderToken = 0;
    var viewer = document.getElementById('viewer');

    function notifyError(err) {
      var msg = (err && err.message) ? err.message : String(err);
      document.getElementById('status').textContent = '$safeFailedPrefix' + msg;
      if (window.ReadingProgress && ReadingProgress.postMessage) {
        ReadingProgress.postMessage(JSON.stringify({ error: msg }));
      }
    }

    function postProgress(force) {
      if (!pageCount) return;
      if (!force && pageNum === lastPostedPage) return;
      lastPostedPage = pageNum;
      var payload = JSON.stringify({ page: pageNum, pages: pageCount });
      if (window.ReadingProgress && ReadingProgress.postMessage) {
        ReadingProgress.postMessage(payload);
      }
    }

    function updateCurrentPageFromScroll() {
      var wraps = viewer.querySelectorAll('.page-wrap[data-page]');
      if (!wraps.length) return;

      var viewTop = viewer.scrollTop;
      var viewMid = viewTop + viewer.clientHeight * 0.35;
      var current = 1;

      for (var i = 0; i < wraps.length; i++) {
        var el = wraps[i];
        var top = el.offsetTop;
        var bottom = top + el.offsetHeight;
        if (bottom > viewMid) {
          current = parseInt(el.getAttribute('data-page'), 10) || (i + 1);
          break;
        }
        current = parseInt(el.getAttribute('data-page'), 10) || (i + 1);
      }

      if (current !== pageNum) {
        pageNum = current;
        postProgress();
      }
    }

    viewer.addEventListener('scroll', function() {
      clearTimeout(scrollTimer);
      scrollTimer = setTimeout(updateCurrentPageFromScroll, 120);
    }, { passive: true });

    function flushProgress() {
      clearTimeout(scrollTimer);
      updateCurrentPageFromScroll();
      postProgress(true);
    }

    document.addEventListener('visibilitychange', function() {
      if (document.visibilityState === 'hidden') flushProgress();
    });
    window.addEventListener('pagehide', flushProgress);

    function scrollToPage(num) {
      var target = viewer.querySelector('.page-wrap[data-page="' + num + '"]');
      if (!target) return;
      viewer.scrollTop = target.offsetTop - 8;
      pageNum = num;
      postProgress(true);
    }

    function pixelRatio() {
      // Cap at 3 to avoid huge canvases / OOM; floor at 2 for sharp text on phones.
      var dpr = window.devicePixelRatio || 1;
      if (dpr < 2) dpr = 2;
      if (dpr > 3) dpr = 3;
      return dpr;
    }

    function cssPageWidth() {
      var width = viewer.clientWidth - 16;
      if (width < 120) width = 120;
      return width;
    }

    function renderPage(num, token) {
      return pdfDoc.getPage(num).then(function(page) {
        if (token !== renderToken) return;

        var base = page.getViewport({ scale: 1 });
        var cssScale = cssPageWidth() / base.width;
        var outputScale = pixelRatio();

        // CSS size = fit to viewer width; bitmap = CSS * DPR for sharp glyphs.
        var viewport = page.getViewport({ scale: cssScale });
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d', { alpha: false });

        canvas.width = Math.floor(viewport.width * outputScale);
        canvas.height = Math.floor(viewport.height * outputScale);
        canvas.style.width = Math.floor(viewport.width) + 'px';
        canvas.style.height = Math.floor(viewport.height) + 'px';

        var wrap = document.createElement('div');
        wrap.className = 'page-wrap';
        wrap.setAttribute('data-page', String(num));
        wrap.appendChild(canvas);
        viewer.appendChild(wrap);

        var renderContext = {
          canvasContext: ctx,
          viewport: viewport,
          transform: outputScale !== 1
            ? [outputScale, 0, 0, outputScale, 0, 0]
            : null
        };

        return page.render(renderContext).promise.then(function() {
          if (token !== renderToken) return;
          if (num === scrollTargetPage) {
            scrollToPage(scrollTargetPage);
          }
        });
      });
    }

    function renderRange(from, to, token) {
      var chain = Promise.resolve();
      for (var i = from; i <= to; i++) {
        (function(n) {
          chain = chain.then(function() {
            if (token !== renderToken) return;
            return renderPage(n, token);
          });
        })(i);
      }
      return chain;
    }

    function clearPages() {
      while (viewer.firstChild) viewer.removeChild(viewer.firstChild);
    }

    function renderAllPages() {
      if (!pdfDoc) return Promise.resolve();
      var token = ++renderToken;
      var savedPage = pageNum || scrollTargetPage || 1;
      clearPages();
      return renderRange(1, pageCount, token).then(function() {
        if (token !== renderToken) return;
        scrollToPage(savedPage);
        updateCurrentPageFromScroll();
      });
    }

    function openPdf() {
      return $loadDocumentJs.promise.then(function(pdf) {
        pdfDoc = pdf;
        pageCount = pdf.numPages;
        if (scrollTargetPage > pageCount) scrollTargetPage = pageCount;
        if (scrollTargetPage < 1) scrollTargetPage = 1;
        pageNum = scrollTargetPage;
        document.getElementById('status').textContent = '';

        var token = ++renderToken;
        return renderRange(1, scrollTargetPage, token).then(function() {
          if (token !== renderToken) return;
          scrollToPage(scrollTargetPage);
          if (scrollTargetPage < pageCount) {
            return renderRange(scrollTargetPage + 1, pageCount, token);
          }
        });
      }).then(function() {
        updateCurrentPageFromScroll();
      });
    }

    var resizeTimer = null;
    window.addEventListener('resize', function() {
      if (!pdfDoc) return;
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function() {
        renderAllPages().catch(function() {});
      }, 250);
    });

    function waitForPdfJs(retries) {
      if (typeof pdfjsLib !== 'undefined') {
        openPdf().catch(notifyError);
        return;
      }
      if (retries <= 0) {
        notifyError('$safePdfJsFailed');
        return;
      }
      setTimeout(function() { waitForPdfJs(retries - 1); }, 200);
    }

    waitForPdfJs(25);
  </script>
</body>
</html>
''';
}

String _jsLoadDocumentFromBase64(String base64) {
  final safeB64 = base64.replaceAll("'", r"\'").replaceAll('\n', '').replaceAll('\r', '');
  return '''
(function() {
  var raw = atob('$safeB64');
  var arr = new Uint8Array(raw.length);
  for (var i = 0; i < raw.length; i++) arr[i] = raw.charCodeAt(i);
  return pdfjsLib.getDocument({ data: arr });
})()
''';
}

String _escapeJsString(String value) {
  return value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", r"\'")
      .replaceAll('\n', r'\n')
      .replaceAll('\r', r'\r');
}
