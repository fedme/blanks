import EasyMDE from "easymde"
import "easymde/dist/easymde.min.css"

let Hooks = {}

Hooks.MarkdownEditor = {
  mounted() {
      this.editor = new EasyMDE({element: this.el})
      this.editor.codemirror.on("change", () => {
        this.pushEvent("content-changed", this.editor.value())
      })
  }
}

export default Hooks