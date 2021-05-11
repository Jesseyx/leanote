# release with docker

```shell
docker build -t leanote .

# run, replace your self dir
docker run -v /d/project-test/leanote:/go/src/leanote leanote
```


# 剪切板不支持粘贴 html

ace.js 的问题

```js
var handleClipboardData = function(e, data, forceIEMime) {
    var clipboardData = e.clipboardData || window.clipboardData;
    if (!clipboardData || BROKEN_SETDATA)
        return;
    // using "Text" doesn't work on old webkit but ie needs it
    var mime = USE_IE_MIME_TYPE || forceIEMime ? "Text" : "text/plain";
    try {
        if (data) {
            // Safari 5 has clipboardData object, but does not handle setData()
            return clipboardData.setData(mime, data) !== false;
        } else {
            return clipboardData.getData(mime);
        }
    } catch(e) {
        if (!forceIEMime)
            return handleClipboardData(e, data, true);
    }
};
```

可以参考 stackEdit 的方案

```js
contentElt.addEventListener('paste', (evt) => {
    undoMgr.setCurrentMode('single');
    evt.preventDefault();
    let data;
    let { clipboardData } = evt;
    if (clipboardData) {
      data = clipboardData.getData('text/plain');
      if (turndownService) {
        try {
          const html = clipboardData.getData('text/html');
          if (html) {
            const sanitizedHtml = htmlSanitizer.sanitizeHtml(html)
              .replace(/&#160;/g, ' '); // Replace non-breaking spaces with classic spaces
            if (sanitizedHtml) {
              data = turndownService.turndown(sanitizedHtml);
            }
          }
        } catch (e) {
          // Ignore
        }
      }
    } else {
      ({ clipboardData } = window.clipboardData);
      data = clipboardData && clipboardData.getData('Text');
    }
    if (!data) {
      return;
    }
    replace(selectionMgr.selectionStart, selectionMgr.selectionEnd, data);
    adjustCursorPosition();
  });
```
