export const mod_keyboard = {
  mounted() {
    document.addEventListener("keydown", this.keydown_handle)
  },

  beforeDestroy() {
    document.removeEventListener("keydown", this.keydown_handle)
  },

  methods: {
    keydown_handle(e) {
      if (e.metaKey || e.altKey || e.ctrlKey || e.shiftKey) {
        return
      }
      if (this.DomHelper.focus_on_input_tag_p()) {
        return
      }

      let processed = false
      if (e.key === "x") {
        this.lap_handle('x')
        processed = true
      }
      if (e.key === "o" || e.code === "Enter") {
        this.lap_handle('o')
        processed = true
      }
      if (e.key === "z") {
        this.revert_handle()
        processed = true
      }
      if (e.key === "r") {
        this.rap_reset()
        processed = true
      }
      if (e.key === "p" || e.key === "k" || e.code === "Space") {
        this.pause_handle()
        processed = true
      }
      if (e.key === "t") {
        this.toggle_handle()
        processed = true
      }
      if (processed) {
        e.preventDefault()
      }
    },
  },
}
