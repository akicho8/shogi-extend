// ウィンドウがアクティブか調べる
// ・focus のとき +1 して blur のとき -1 することで、必ず 0 か 1 になると予想したが、そうならなかった
// ・mobile safari の共有リンクで Twitter App に飛んで戻ったとき 0 でも 1 でもなくなる
// ・なので focus や blur の一方が連続で呼ばれるのを考慮しないといけない
//
// 2021-11-23 スマホの focus, blur 問題
// ・上下にスクロールした時点で blur になってしまう
// ・なので visibilitychange に変更
//
// 参照
// https://developer.mozilla.org/ja/docs/Web/API/Page_Visibility_API
// https://developer.mozilla.org/ja/docs/Web/API/Document/visibilitychange_event

export const window_activity_detector = {
  data() {
    return {
      latest_window_active_p: null, // ここで this.__native_window_active_p() を呼ぶと SSR でひっかる
    }
  },

  // client でしか呼ばれないのでここで呼ぶ
  mounted() {
    this.latest_window_active_p = this.__native_window_active_p()
    document.addEventListener("visibilitychange", this.__visibilitychange_hook)
  },

  beforeDestroy() {
    document.removeEventListener("visibilitychange", this.__visibilitychange_hook)
  },

  methods: {
    __native_window_active_p()   { return document.visibilityState === "visible" },
    __native_window_inactive_p() { return document.visibilityState === "hidden"  },

    __visibilitychange_hook() {
      this.tl_add("HOOK", document.visibilityState)
      this.__window_active_change_hook(this.__native_window_active_p())
    },

    __window_active_change_hook(active_p) {
      this.latest_window_active_p = active_p
      if (active_p) {
        const fn = this.window_active_fn
        if (fn) {
          fn()
        }
      } else {
        const fn = this.window_inactive_fn
        if (fn) {
          fn()
        }
      }
      {
        const fn = this.window_activity_change_fn
        if (fn) {
          fn(active_p)
        }
      }
    },
  },
}
