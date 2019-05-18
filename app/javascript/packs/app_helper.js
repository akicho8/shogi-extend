// どこに書いたらいいかわからない機能シリーズ

import axios from "axios"

// 指定 URL の結果をクリップボードにコピー
export function kifu_copy_exec(params) {
  params = Object.assign({}, {
    success_message: "棋譜をクリップボードにコピーしました",
  }, params)

  const kc_url = params["kc_url"]
  if (kc_url) {
    const kc_format = params["kc_format"] || "kif"
    const kifu_text = $.ajax({ // このためだけに jQuery 使用
      type: "GET",
      url: `${kc_url}.${kc_format}?copy_trigger=true`,
      async: false, // 実際のクリックのタイミングでしかクリップボードへのコピーは作動しないという鬼仕様のため同期(重要)
    }).responseText

    params["text"] = kifu_text
  }

  const kc_title = params["kc_title"]
  if (kc_title) {
    params["success_yomiage"]= `${kc_title}の棋譜をクリップボードにコピーしました`
  }

  clipboard_copy(params)
}

// str をクリップボードにコピー
export function clipboard_copy(params) {
  params = Object.assign({}, {
    success_message: "クリップボードにコピーしました",
    error_message: "クリップボードへのコピーに失敗しました",
    success_yomiage: "コピーしました",
    error_yomiage: "失敗しました",
  }, params)

  let success = null

  // この方法は iPhone で動かない。先に elem.select() を実行した時点で iPhone の方が作動しなくなる
  if (false) {
    const elem = document.createElement("textarea")
    elem.value = params["text"]
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
  }

  // https://marmooo.blogspot.com/2018/02/javascript.html
  if (true) {
    const elem = document.createElement('textarea')
    document.body.appendChild(elem)
    elem.value = params["text"]
    success = corresponded_to_ios_pc_android_copy_to_clipboard(elem)
    document.body.removeChild(elem)
  }

  if (!success) {
    talk(params["error_yomiage"])
    Vue.prototype.$toast.open({message: params["error_message"], position: "is-bottom", type: "is-danger"})
    return
  }

  talk(params["success_yomiage"])
  Vue.prototype.$toast.open({message: params["success_message"], position: "is-bottom", type: "is-success"})
}

// https://marmooo.blogspot.com/2018/02/javascript.html
function corresponded_to_ios_pc_android_copy_to_clipboard(el) {
  // resolve the element
  el = (typeof el === 'string') ? document.querySelector(el) : el

  // handle iOS as a special case
  if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {

    // save current contentEditable/readOnly status
    const editable = el.contentEditable
    const readOnly = el.readOnly

    // convert to editable with readonly to stop iOS keyboard opening
    el.contentEditable = true
    el.readOnly = true

    // create a selectable range
    const range = document.createRange()
    range.selectNodeContents(el)

    // select the range
    const selection = window.getSelection()
    selection.removeAllRanges()
    selection.addRange(range)
    el.setSelectionRange(0, 999999)

    // restore contentEditable/readOnly to original state
    el.contentEditable = editable
    el.readOnly = readOnly
  } else {
    el.select()
  }

  // execute copy command
  return document.execCommand('copy')
}

// ログイン強制
export function login_required() {
  if (!js_global.current_user) {
    location.href = js_global.login_path
    return true
  }
}

// しゃべる
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

    // FIFO形式で順次発声
    if (true) {
      audio_queue.media_push(response.data.service_path)
    }

  }).catch((error) => {
    Vue.prototype.$toast.open({message: error.message, position: "is-bottom", type: "is-danger"})
  })
}
