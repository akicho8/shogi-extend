export const app_keyboard = {
  mounted() {
    document.addEventListener("keydown", this.keydown_handle)
  },

  beforeDestroy() {
    document.removeEventListener("keydown", this.keydown_handle)
  },

  methods: {
    keydown_handle(e) {
      if (this.is_running_p || this.development_p) {
        this.clog(e)
        let processed = false
        // if (e.metaKey || e.altKey || e.ctrlKey || e.shiftKey) {
        //   return
        // }
        if (this.focus_on_input_tag_p()) {
          return
        }
        if (e.key === "x") {
          this.kb_next_handle("mistake")
          processed = true
        }
        if (e.key === "o" || e.code === "Enter") {
          this.kb_next_handle("correct")
          processed = true
        }
        if (e.key === "q" || e.code === "Escape") {
          this.quit_handle()
          processed = true
        }
        if (e.code === "Backspace") {
          this.previous_handle()
          processed = true
        }
        if (e.key === "?") {
          this.kb_shortcut_modal_toggle_handle()
          processed = true
        }
        if (processed) {
          e.preventDefault()
        }
      }
    },

    kb_next_handle(answer_kind_key) {
      if (this.current_xitem) {
        if (this.current_article.invisible_p) {
          this.skip_handle()
        } else {
          this.next_handle(this.AnswerKindInfo.fetch(answer_kind_key))
        }
      }
    },

    focus_on_input_tag_p() {
      const dom = document.activeElement
      return dom.tagName === "TEXTAREA" || dom.tagName === "INPUT"
    },
  },
}
