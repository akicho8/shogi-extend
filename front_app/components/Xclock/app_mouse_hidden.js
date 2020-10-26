// 時間がたつとマウスを消す

import _ from "lodash"

const MOUSE_CURSOR_HIDDEN_DELAY = 3

export const app_mouse_hidden = {
  data() {
    return {
      mouse_cursor_p: true,
    }
  },

  mounted() {
    document.addEventListener("mousemove", this.mouse_move_handle)
  },

  beforeDestroy() {
    document.removeEventListener("mousemove", this.mouse_move_handle)
  },

  methods: {
    mouse_move_handle() {
      this.mouse_cursor_p = true
      this.mouse_cursor_off()
    },

    mouse_cursor_off: _.debounce(function() {
      this.mouse_cursor_p = false
    }, 1000 * MOUSE_CURSOR_HIDDEN_DELAY),
  },
}
