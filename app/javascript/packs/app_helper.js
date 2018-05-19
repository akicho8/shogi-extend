// どこに書いたらいいかわからない機能シリーズ

// .kif_clipboard_copy_button の要素を一括でアレする
export function kifu_copy_hook_all() {
  const elems = document.querySelectorAll(".kif_clipboard_copy_button")
  elems.forEach(el => {
    el.addEventListener("click", e => {
      const url = e.target.dataset[_.camelCase("kif_direct_access_path")]
      kifu_copy_exec(url)
      e.preventDefault()
    })
  })
}

// 指定 URL の結果をクリップボードにコピー
export function kifu_copy_exec(url) {
  if (!url) {
    alert("棋譜のURLが不明です")
  }

  const kifu_text = $.ajax({
    type: "GET",
    url: url,
    async: false, // 実際のクリックのタイミングでしかクリップボードへのコピーは作動しないという鬼仕様のため同期(重要)
  }).responseText

  clipboard_copy(kifu_text)
}

// str をクリップボードにコピー
export function clipboard_copy(str, __options = {}) {
  const options = Object.assign({}, {
    success_message: "クリップボードにコピーしました",
    error_message: "クリップボードへのコピーに失敗しました",
  }, __options)

  // クリップボード関連ライブラリを使わなくてもこれだけで動作する
  const elem = document.createElement("textarea")
  elem.value = str
  document.body.appendChild(elem)
  elem.select()
  const success = document.execCommand("copy") // なんの嫌がらせか実際にクリックしていないと動作しないので注意
  document.body.removeChild(elem)

  if (success) {
    Vue.prototype.$toast.open({message: options["success_message"], position: "is-bottom", type: "is-success"})
  } else {
    Vue.prototype.$toast.open({message: options["error_message"], position: "is-bottom", type: "is-danger"})
  }
}
