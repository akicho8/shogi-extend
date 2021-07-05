import { isMobile } from "../components/models/is_mobile.js"

export default {
  methods: {
    mobile_p()  { return isMobile.any()  },
    desktop_p() { return !isMobile.any() },

    ////////////////////////////////////////////////////////////////////////////////

    // // 他のウィンドウで開く
    // url_open(url) {
    //   // this.process_now()
    //   if (window.open(url, "_self")) {
    //     // Google Chrome では動く
    //   } else {
    //     // iOS Safari ではこちら
    //     this.url_open(url)
    //   }
    // },

    // URLを開く
    // url_open(url, this.target_default) で呼ぶとPCの場合はWindowを開く
    url_open(url, target = null) {
      if (target === "_blank") {
        return this.other_window_open(url)
      }

      // this.process_now()
      location.href = url
    },

    other_window_open(url) {
      window.open(url, "_blank")
    },

    window_popup(url, options = {}) {
      // https://developer.mozilla.org/ja/docs/Web/API/Window/open
      // https://qiita.com/yun_bow/items/356f21fc376133037d84
      options = {
        width: 800,
        height: 640,
        location: "no",         // Chrome では効かない
        status: "no",
        ...options,
      }
      const left = (window.screen.width  - options.width)  / 2
      const top  = (window.screen.height - options.height) / 2
      options = { top, left, ...options }
      const features = _.map(options, (v, k) => `${k}=${v}`).join(",")
      window.open(url, "_blank", features)
    },

    window_popup_if_desktop(url, options = {}) {
      if (this.desktop_p) {
        this.window_popup(url, options)
      } else {
        location.href = url
      }
    },

    sp_turn_slider_auto_focus() {
      this.desktop_focus_to(this.$el.querySelector(".turn_slider"))
    },

    // モバイルでないときだけ elem にフォーカスする
    // なぜか $nextTick ではフォーカスされない場合があるため setTimeout に変更
    desktop_focus_to(elem) {
      if (!isMobile.any()) {
        this.focus_to(elem)
      }
    },

    // $nextTick ではフォーカスされない場合があるため setTimeout にしている
    // それでも 2msec だと効かない場合もあるため 0.1 秒待つようにしている
    // が、1 でも効いた。
    focus_to(elem) {
      if (elem) {
        setTimeout(() => elem.focus(), 1)
      }
    },
  },

  computed: {
    // スマホ → _self
    //    PC  → _blank
    target_default() {
      return isMobile.any() ? "_self" : "_blank"
    },
  },
}
