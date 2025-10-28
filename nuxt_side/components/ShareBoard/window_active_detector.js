// ウィンドウがアクティブか調べる
// ・focus のとき +1 して blur のとき -1 することで、必ず 0 か 1 になると予想したが、そうならなかった
// ・mobile safari の共有リンクで Twitter App に飛んで戻ったとき 0 でも 1 でもなくなる
// ・なので focus や blur の一方が連続で呼ばれるのを考慮しないといけない
//
// 2021-11-23 スマホの focus, blur 問題
// ・上下にスクロールした時点で blur になってしまう
// ・なので visibilitychange に変更

export const window_active_detector = {
  data() {
    return {
      window_active_p: null, // ここで this.__native_window_active_p() を呼ぶと SSR でひっかる
    }
  },

  // client でしか呼ばれないのでここで呼ぶ
  mounted() {
    this.window_active_p = this.__native_window_active_p()
    document.addEventListener("visibilitychange", this.__visibilitychange_hook)
  },

  beforeDestroy() {
    document.removeEventListener("visibilitychange", this.__visibilitychange_hook)
  },

  methods: {
    // private
    __native_window_active_p() {
      return document.visibilityState === "visible"
    },

    __visibilitychange_hook() {
      if (this.debug_mode_p) {
        this.tl_add("HOOK", document.visibilityState)
      }
      this.__window_active_change_hook(this.__native_window_active_p())
    },

    __window_active_change_hook(focus_p) {
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
