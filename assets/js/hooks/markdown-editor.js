import Hashids from 'hashids'
import EasyMDE from "easymde"

const hashids = new Hashids()

const MDEOptions = [
  "bold", "italic", "heading", "|", "quote", "unordered-list", "ordered-list", "|", "image", "guide", "|",
  {
    name: "insert-blank",
    action: function customFunction(editor) {
      console.log(editor)
      var cm = editor.codemirror
      var stat = editor.getState()
      var options = editor.options
      _replaceSelection(cm, stat.link, options.insertTexts.link, hashids.encode(Date.now()))
    },
    className: "icon-insert-blank",
    title: "Insert blank",
  },
]

const MarkdownEditor = {
  mounted() {
    this.editor = new EasyMDE({
      element: this.el,
      toolbar: MDEOptions
    })
    this.editor.codemirror.on("change", () => {
      this.pushEvent("content-changed", this.editor.value())
    })
  },
  
  updated() {
    this.editor = new EasyMDE({
      element: this.el,
      toolbar: MDEOptions
    })
    this.editor.codemirror.on("change", () => {
      this.pushEvent("content-changed", this.editor.value())
    })
  }
}

// from https://github.com/Ionaru/easy-markdown-editor/blob/master/src/js/easymde.js
function _replaceSelection(cm, active, startEnd, url) {
  if (/editor-preview-active/.test(cm.getWrapperElement().lastChild.className))
    return;

  var text;
  var start = startEnd[0];
  var end = startEnd[1];
  var startPoint = {},
    endPoint = {};
  Object.assign(startPoint, cm.getCursor('start'));
  Object.assign(endPoint, cm.getCursor('end'));
  if (url) {
    start = start.replace('#url#', url);  // url is in start for upload-image
    end = end.replace('#url#', url);
  }
  if (active) {
    text = cm.getLine(startPoint.line);
    start = text.slice(0, startPoint.ch);
    end = text.slice(startPoint.ch);
    cm.replaceRange(start + end, {
      line: startPoint.line,
      ch: 0,
    });
  } else {
    text = cm.getSelection();
    cm.replaceSelection(start + text + end);

    startPoint.ch += start.length;
    if (startPoint !== endPoint) {
      endPoint.ch += start.length;
    }
  }
  cm.setSelection(startPoint, endPoint);
  cm.focus();
}

export default MarkdownEditor