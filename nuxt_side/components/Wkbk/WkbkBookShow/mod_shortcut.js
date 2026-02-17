export const mod_shortcut = {
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
        if (this.DomHelper.focus_on_input_tag_p()) {
          return
        }
        let processed = false
        if (e.key === "?") {
          this.kb_shortcut_modal_shortcut_handle()
          processed = true
        }
        if (this.KeyboardHelper.pure_key_p(e, "x")) {
          this.kb_next_handle("mistake")
          processed = true
        }
        if (this.KeyboardHelper.pure_key_p(e, "o") || e.code === "Enter") {
          this.kb_next_handle("correct")
          processed = true
        }
        if (this.KeyboardHelper.pure_key_p(e, "q") || e.code === "Escape") {
          this.quit_handle()
          processed = true
        }
        if (e.code === "Backspace") {
          this.previous_handle()
          processed = true
        }
        if (this.KeyboardHelper.pure_key_p(e, "p") || e.code === "Space") {
          this.sidebar_toggle()
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
  },
}
