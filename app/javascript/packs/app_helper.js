// どこに書いたらいいかわからない機能シリーズ

import axios from "axios"
import no_sound from "./no_sound.mp3"

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
    talk(options["success_message"])
    Vue.prototype.$toast.open({message: options["success_message"], position: "is-bottom", type: "is-success"})
  } else {
    talk(options["error_message"])
    Vue.prototype.$toast.open({message: options["error_message"], position: "is-bottom", type: "is-danger"})
  }
}

// ログイン強制
export function login_required() {
  if (!js_global.current_user) {
    location.href = js_global.login_path
    return true
  }
}

// こうするとグローバル変数にできる
// var で定義するとグローバルにはなってない
window.global_audio = new Audio()
window.global_audio_counter = 0
window.global_audio_standby_mode = true
window.global_src_stack = []

document.addEventListener("touchstart", () => {
  global_audio_play(no_sound)
})

global_audio.addEventListener("ended", () => {
  // console.log(`global_audio.ended:${JSON.stringify(global_audio.ended)}`)
  if (global_src_stack.length == 0) {
    global_audio_standby_mode = true
  } else {
    global_audio_play_next()
  }
}, false)

function global_audio_play_next() {
  if (global_src_stack.length >= 1) {
    global_audio_standby_mode = false
    global_audio.src = global_src_stack.shift()
    global_audio.play()
  }
}

function global_audio_play(audio_file_path) {
  global_src_stack.push(audio_file_path)
  if (global_audio_standby_mode) {
    global_audio_play_next()
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
      if (!global_audio) {
        global_audio = new Audio()
      }
      global_audio.src = response.data.service_path
      global_audio.play()
    }

    // FIFO 形式で順次発声
    if (true) {
      global_audio_play(response.data.service_path)
    }

  }).catch((error) => {
    Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
  })
}
