// ウィンドウがアクティブか調べる

export const window_active_check = {
  data() {
    return {
      window_active_count: null, // ここで this.native_window_has_focus_p() を呼ぶと SSR でひっかる
    }
  },

  // client でしか呼ばれないのでここで呼ぶ
  mounted() {
    this.window_active_count = this.native_window_has_focus_p() ? 1 : 0

    window.addEventListener("focus", this.window_focus_hook)
    window.addEventListener("blur", this.window_blur_hook)
  },

  beforeDestroy() {
    window.removeEventListener("focus", this.window_focus_hook)
    window.removeEventListener("blur", this.window_blur_hook)
  },

  methods: {
    native_window_has_focus_p() {
      return document.hasFocus()
    },
    window_focus_hook() {
      this.window_focus_blur_hook(true)
    },
    window_blur_hook() {
      this.window_focus_blur_hook(false)
    },

    // private

    window_focus_blur_hook(focus_p) {
      if (focus_p) {
        this.window_active_count += 1
        if (this.window_focus_user_after_hook) {
          this.window_focus_user_after_hook()
        }
      } else {
        this.window_active_count -= 1
        if (this.window_blur_user_after_hook) {
          this.window_blur_user_after_hook()
        }
      }
      if (this.window_focus_blur_user_hook) {
        this.window_focus_blur_user_hook(focus_p)
      }
    },
  },
}
