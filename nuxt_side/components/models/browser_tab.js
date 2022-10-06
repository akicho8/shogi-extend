export const BrowserTab = {
  // タブが見えている状態か？
  // フォーカスされてない状態でも見えていれば true になる
  // つまり2窓で隣にYoutubeを開いてチャットを入力中であっても左側のブラウザは true になる
  active_p() {
    return document.visibilityState === "visible"
  },

  // https://developer.mozilla.org/ja/docs/Web/API/Document/visibilityState
  // document.visibilityState は visible か hidden を返す
  hidden_p() {
    return document.visibilityState === "hidden"
  },
}
