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
export const up_down_scroll_disable = {
  created() {
    document.addEventListener("touchmove", this.up_down_scroll_disable_handle, {passive: false})
  },
  beforeDestroy() {
    document.removeEventListener("touchmove", this.up_down_scroll_disable_handle, {passive: false})
  },
  methods: {
    up_down_scroll_disable_handle(e) {
      e.preventDefault()
    },
  },
}
