document.addEventListener("DOMContentLoaded", () => {
  class MsEdgeRedirect {
    static run() {
      if (!window.navigator.userAgent.match(/Windows.*Edge/)) {
        alert("ブラウザが古いため動作しません\n外部サイトに移動しますので新しい Microsoft Edge を入手してください")
        location.href = "https://support.microsoft.com/ja-jp/help/4501095/download-the-new-microsoft-edge-based-on-chromium"
      }
    }
  }
  MsEdgeRedirect.run()
})
