// ウィンドウがアクティブか調べる

// const USE_VISIBILITYCHANGE = true

export const window_active_check = {
  data() {
    return {
      window_active_count: null, // ここで this.native_window_has_focus_p() を呼ぶと SSR でひっかる
    }
  },

  // client でしか呼ばれないのでここで呼ぶ
  mounted() {
    this.window_active_count = this.native_window_has_focus_p() ? 1 : 0

    // document.addEventListener("visibilitychange", this.visibilitychange_hook)
    window.addEventListener("focus", this.window_focus_hook)
    window.addEventListener("blur", this.window_blur_hook)
  },

  beforeDestroy() {
    // document.removeEventListener("visibilitychange", this.visibilitychange_hook)
    window.removeEventListener("focus", this.window_focus_hook)
    window.removeEventListener("blur", this.window_blur_hook)
  },

  methods: {
    native_window_has_focus_p() {
      // return document.visibilityState === "visible" && document.hasFocus()
      // return document.hasFocus()
      // return document.visibilityState === "visible"
      return document.hasFocus()
    },
    window_focus_hook() {
      // this.tl_add("HOOK", "focus")
      this.window_active_change_hook(true)
    },
    window_blur_hook() {
      // this.tl_add("HOOK", "blur")
      this.window_active_change_hook(false)
    },
    visibilitychange_hook() {
      // this.tl_add("HOOK", `visibilitychange: ${focus_p}`)
      this.window_active_change_hook(this.native_window_has_focus_p())
    },

    // private

    window_active_change_hook(focus_p) {
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
      this.__assert__(this.window_active_count === 0 || this.window_active_count === 1, "this.window_active_count === 0 || this.window_active_count === 1")
      if (this.window_active_change_user_hook) {
        this.window_active_change_user_hook(focus_p)
      }
    },
  },
}
