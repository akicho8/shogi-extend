// https://qiita.com/shge/items/d2ae44621ce2eec183e6
//
// 左右スクロールしてしまうそもそもの原因は？
//
//   コンテンツが横にはみ出ている。これを入れずにそれを直せ。
//
// overflow: hidden してもスクロールしてしまう
//
//   iPhoneでは効かない。それはPC用
//
// 結局どうすれば？
//
//   これをいれて touchmove を無効にする
//
// 効いてなくない？
//
//   passive: false をしないと preventDefault() は効かない
//
export const vue_scroll = {
  methods: {
    scroll_set(v) {
      if (v) {
        if (this.development_p) {
          this.toast_primary("scroll_on")
        }
        this.scroll_on()
      } else {
        if (this.development_p) {
          this.toast_primary("scroll_off")
        }
        this.scroll_off()
      }
    },
    scroll_on() {
      document.removeEventListener("touchmove", this.__scroll_disable_handle, {passive: false})
    },
    scroll_off() {
      this.scroll_on()
      document.addEventListener("touchmove", this.__scroll_disable_handle, {passive: false})
    },
    __scroll_disable_handle(e) {
      e.preventDefault()
    },
  },
}
