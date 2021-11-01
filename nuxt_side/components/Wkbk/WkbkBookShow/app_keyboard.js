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
        if (this.focus_on_input_tag_p()) {
          return
        }
        let processed = false
        if (e.key === "?") {
          this.kb_shortcut_modal_toggle_handle()
          processed = true
        }
        if (this.kb_single_p(e, "x")) {
          this.kb_next_handle("mistake")
          processed = true
        }
        if (this.kb_single_p(e, "o") || e.code === "Enter") {
          this.kb_next_handle("correct")
          processed = true
        }
        if (this.kb_single_p(e, "q") || e.code === "Escape") {
          this.quit_handle()
          processed = true
        }
        if (e.code === "Backspace") {
          this.previous_handle()
          processed = true
        }
        if (this.kb_single_p(e, "p") || e.code === "Space") {
          this.sidebar_toggle()
          processed = true
        }
        if (processed) {
          e.preventDefault()
        }
      }
    },

    kb_meta_p(e) {
      return e.metaKey || e.altKey || e.ctrlKey || e.shiftKey
    },

    kb_single_p(e, key) {
      return !this.kb_meta_p(e) && e.key === key
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
