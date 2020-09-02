export const app_keyboard_shortcut = {
  mounted() {
    document.addEventListener("keydown", this.keydown_handle)
  },

  beforeDestroy() {
    document.removeEventListener("keydown", this.keydown_handle)
  },

  methods: {
    keydown_handle(e) {
      if (this.development_p) {
        console.log(e, e.shiftKey, e.ctrlKey, e.altKey, e.metaKey, e.key, e.code)
      }

      const dom = document.activeElement
      if (dom.tagName === "TEXTAREA" || dom.tagName === "INPUT") {
        return
      }

      // if (!this.chess_clock.pause_p) {
      //   if (["Escape"].includes(e.code)) {
      //     this.pause_handle()
      //     e.preventDefault()
      //   }
      // }

      if (!this.chess_clock.zero_arrival) {
        if (["ShiftLeft", "ControlLeft", "Tab", "Space"].includes(e.code)) {
          this.switch_handle(this.chess_clock.single_clocks[0])
          e.preventDefault()
        }
        if (["ShiftRight", "ControlRight", "Enter", "ArrowRight", "ArrowUp", "ArrowDown", "ArrowLeft"].includes(e.code)) {
          this.switch_handle(this.chess_clock.single_clocks[1])
          e.preventDefault()
        }
      }
    },
  },
}
