export const WinTab = {
  // タブが見えている状態か？
  // ブラウザ自体が非アクティブ状態(フォーカスされてない状態)でも true になる
  // つまり2窓で隣にYoutubeを開いてチャットを入力中であっても左側のブラウザは true になる
  // setInterval(() => console.log(this.tab_is_active_p()), 1000)
  tab_is_active_p() {
    return document.visibilityState === "visible"
  },

  // https://developer.mozilla.org/ja/docs/Web/API/Document/visibilityState
  // document.visibilityState は visible か hidden を返す
  tab_is_hidden_p() {
    return document.visibilityState === "hidden"
  },
}
