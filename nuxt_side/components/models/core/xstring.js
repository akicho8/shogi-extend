import { Xassertion } from "./xassertion.js"

export const Xstring = {
  // 文字列をクラス化
  // ・window に結び付いてないと取得できない
  // ・return Function(`return ${str}`)() は window[str]() とするのとかわらない
  str_constantize(str) {
    Xassertion.__assert__(typeof window !== 'undefined', "typeof window !== 'undefined'")
    Xassertion.__assert__(window[str], "window[str]")
    return window[str]
  },

  hira_to_kata(str) {
    return str.replace(/[\u3041-\u3096]/g, ch => String.fromCharCode(ch.charCodeAt(0) + 0x60))
  },

  kana_to_hira(str) {
    return str.replace(/[\u30A1-\u30FA]/g, ch => String.fromCharCode(ch.charCodeAt(0) - 0x60))
  },

  hankaku_format(str) {
    return str.replace(/[Ａ-Ｚａ-ｚ０-９]/g, s => String.fromCharCode(s.charCodeAt(0) - 0xFEE0))
  },

  str_to_boolean(str) {
    str = (str ?? "").toString().trim()
    return ["1", "t", "true", "on", "enabled", "enable"].includes(str)
  },
}
