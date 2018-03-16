export function kifu_copy_hook_all() {
  const buttons = document.querySelectorAll(".kif_clipboard_copy_button")
  for (let i = 0; i < buttons.length; i++) {
    buttons[i].addEventListener("click", (e) => {
      const url = e.target.dataset.kifDirectAccessPath // kif_direct_access_path
      kifu_copy_exec(url)
      e.preventDefault()
    })
  }
}

export function kifu_copy_exec(url) {
  if (!url) {
    alert("棋譜のURLが不明です")
  }
  const kifu_text = $.ajax({type: "GET", url: url, async: false}).responseText // 実際のクリックのタイミングでしかクリップボードへのコピーは作動しないという鬼仕様のため同期(重要)
  clipboard_copy(kifu_text)
}

export function clipboard_copy(str, _options = {}) {
  const options = Object.assign({}, {
    success_message: "クリップボードにコピーしました",
    error_message: "クリップボードへのコピーに失敗しました",
  }, _options)

  const elem = document.createElement("textarea")
  elem.value = str
  document.body.appendChild(elem)
  elem.select()
  const success = document.execCommand("copy")
  document.body.removeChild(elem)

  if (success) {
    Vue.prototype.$toast.open({message: options["success_message"], position: "is-bottom", type: "is-success"})
  } else {
    Vue.prototype.$toast.open({message: options["error_message"], position: "is-bottom", type: "is-danger"})
  }
}
