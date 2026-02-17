export const mod_keyboard_shortcut = {
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

      if (this.DomHelper.focus_on_input_tag_p()) {
        return
      }

      // 動作中かつポーズ中は操作禁止
      if (this.clock_box.pause_or_play_p && this.clock_box.timer == null) {
        return
      }

      // 時間切れになったあとは操作禁止
      if (this.clock_box.any_zero_p) {
        return
      }

      // 左
      if (["ShiftLeft", "ControlLeft", "Tab"].includes(e.code)) {
        this.xswitch_handle(this.clock_box.single_clocks[0])
        e.preventDefault()
      }

      // 右
      if (["ShiftRight", "ControlRight", "Enter", "ArrowRight", "ArrowUp", "ArrowDown", "ArrowLeft"].includes(e.code)) {
        this.xswitch_handle(this.clock_box.single_clocks[1])
        e.preventDefault()
      }
    },
  },
}
