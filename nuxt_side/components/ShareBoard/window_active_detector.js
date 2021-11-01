// ウィンドウがアクティブか調べる
// ・focus のとき +1 して blur のとき -1 することで 0 か 1 になるのか？
// ・mobile safari のツイートリンクで Twitter App に飛んで戻ったとき 0 でも 1 でもなくなる
// ・なので focus や blur の一方が連続で呼ばれるのを考慮しないといけない

// const USE_VISIBILITYCHANGE = true

export const window_active_detector = {
  data() {
    return {
      window_active_p: null, // ここで this.native_window_active_p() を呼ぶと SSR でひっかる
    }
  },

  // client でしか呼ばれないのでここで呼ぶ
  mounted() {
    this.window_active_p = this.native_window_active_p()

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
    // private
    native_window_active_p() {
      // return document.visibilityState === "visible" && document.hasFocus()
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
      this.window_active_change_hook(this.native_window_active_p())
    },
    window_active_change_hook(focus_p) {
      this.window_active_p = focus_p
      if (focus_p) {
        if (this.window_focus_user_after_hook) {
          this.window_focus_user_after_hook()
        }
      } else {
        if (this.window_blur_user_after_hook) {
          this.window_blur_user_after_hook()
        }
      }
      if (this.window_active_change_user_hook) {
        this.window_active_change_user_hook(focus_p)
      }
    },
  },
}
