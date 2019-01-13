// どこに書いたらいいかわからない機能シリーズ

import axios from "axios"

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

  clipboard_copy(kifu_text, {success_message: "棋譜をクリップボードにコピーしました"})
}

// str をクリップボードにコピー
export function clipboard_copy(str, options = {}) {
  const options2 = Object.assign({}, {
    success_message: "クリップボードにコピーしました",
    error_message: "クリップボードへのコピーに失敗しました",
  }, options)

  let success = null

  const elem = document.createElement("textarea")
  elem.value = str
  document.body.appendChild(elem)
  elem.select() // この方法は Windows Chrome でのみ動く
  success = document.execCommand("copy") // なんの嫌がらせか実際にクリックしていないと動作しないので注意
  console.log(`クリップボードコピー試行1: select => ${success}`)

  if (!success) {
    // この方法は iPhone と Mac の Chrome で動く。Mac の Safari では未検証
    const range = document.createRange()
    range.selectNode(elem)
    window.getSelection().addRange(range)
    success = document.execCommand("copy")
    console.log(`クリップボードコピー試行2: selectNode => ${success}`)
  }

  document.body.removeChild(elem)

  if (success) {
    talk("コピーしました")
    Vue.prototype.$toast.open({message: options2["success_message"], position: "is-bottom", type: "is-success"})
  } else {
    talk("失敗しました")
    Vue.prototype.$toast.open({message: options2["error_message"], position: "is-bottom", type: "is-danger"})
  }
}

// ログイン強制
export function login_required() {
  if (!js_global.current_user) {
    location.href = js_global.login_path
    return true
  }
}

export function talk(source_text) {
  // const params = new URLSearchParams()
  // params.append("source_text", source_text)
  // axios.post(js_global.talk_path, params).then((response) => {
  axios.get(js_global.talk_path, {params: {source_text: source_text}}).then(response => {
    // すぐに発声する場合
    if (false) {
      const audio = new Audio()
      audio.src = response.data.service_path
      audio.play()
    }

    // 最後に来た音声のみ発声
    if (false) {
      if (!audio) {
        audio = new Audio()
      }
      audio.src = response.data.service_path
      audio.play()
    }

    // FIFO 形式で順次発声
    if (true) {
      audio_queue.media_push(response.data.service_path)
    }

  }).catch((error) => {
    Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
  })
}
