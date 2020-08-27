export const application_shortcut = {
  mounted() {
    document.addEventListener("keydown", this.keydown_handle)
  },

  beforeDestroy() {
    document.removeEventListener("keydown", this.keydown_handle)
  },

  methods: {
    keydown_handle(e) {
      if (this.development_p) {
        console.log(e.shiftKey, e.ctrlKey, e.altKey, e.metaKey)
        console.log("e", e)
        console.log("key", e.key)
        console.log("code", e.code)
      }

      const dom = document.activeElement
      if (dom.tagName === "TEXTAREA" || dom.tagName === "INPUT") {
        return
      }

      if (["ShiftLeft", "ControlLeft", "Tab", "Space"].includes(e.code)) {
        this.switch_handle(this.chess_clock.single_clocks[0])
        e.preventDefault()
      }

      if (["ShiftRight", "ControlRight", "Enter", "ArrowRight"].includes(e.code)) {
        this.switch_handle(this.chess_clock.single_clocks[1])
        e.preventDefault()
      }
    },
  },
}
