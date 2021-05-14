# release with docker

```shell
docker build -t leanote .

# run, replace your self dir
docker run -v /d/project-test/leanote:/go/src/leanote leanote
```

# docker-compose 部署

1. 在 `docker-compose.yml` 中修改 `root` 密码
2. 在 `db_leanote.js` 中修改 `leanote` 数据库的密码
3. 将 `leanote` 数据库密码更新到 `conf/app.conf` 中
4. 修改 `conf/app.conf` 中 `db.host` 为 `mongo`, it's image name in compose

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
