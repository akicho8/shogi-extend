// 時間がたつとマウスを消す

import _ from "lodash"

const MOUSE_CURSOR_HIDDEN_DELAY_SEC = 3

export const mouse_cursor_hidden_mixin = {
  data() {
    return {
      mouse_cursor_p: true,
    }
  },

  created() {
    this.mouse_cursor_off_debounce_on()
  },

  mounted() {
    document.addEventListener("mousemove", this.mouse_move_handle)
  },

  beforeDestroy() {
    document.removeEventListener("mousemove", this.mouse_move_handle)
    this.mouse_cursor_off_debounce_off()
  },

  methods: {
    mouse_move_handle() {
      this.mouse_cursor_p = true
      this.mouse_cursor_off()
    },

    // X秒後に呼ぶ設定
    mouse_cursor_off_debounce_on() {
      this.mouse_cursor_off_debounce_trailing = _.debounce(() => { this.mouse_cursor_off_task() }, MOUSE_CURSOR_HIDDEN_DELAY_SEC * 1000, { leading: false, trailing: true })
    },
    mouse_cursor_off_debounce_off() {
      this.debug_alert("mouse_cursor_off_debounce_off")
      this.mouse_cursor_off_debounce_trailing.cancel()
    },
    // 操作時に毎回呼ぶ
    mouse_cursor_off() {
      this.mouse_cursor_off_debounce_trailing()
    },
    // 操作後X秒後に呼ぶ
    mouse_cursor_off_task() {
      this.debug_alert("mouse_cursor_off_task")
      this.mouse_cursor_p = false
    },
  },
}
