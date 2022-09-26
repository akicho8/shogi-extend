import { Xassertion } from "./xassertion.js"
import { Xobject } from "./xobject.js"
import _ from "lodash"

export const Xstring = {
  // 文字列をクラス化
  // ・window に結び付いてないと取得できない
  // ・return Function(`return ${str}`)() は window[str]() とするのとかわらない
  // ・自作の Foo クラスを window.Foo = Foo としてもビルドすると Foo は別名の1文字になっていたりするのでこれでは引けない
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

  str_squish(str) {
    str = (str || "").toString()
    str = str.replace(/[\s\u3000]+/g, " ")
    str = str.trim()
    return str
  },

  str_strip(str) {
    str = (str || "").toString()
    str = str.replace(/^[\s\u3000]+/, "")
    str = str.replace(/[\s\u3000]+$/, "")
    return str
  },

  // str_to_tags("a,b,a") // => ["a", "b", "a"]
  str_to_words(str) {
    str = (str || "").toString()
    str = str.replace(/,/g, " ")
    str = this.str_squish(str)
    let av = []
    if (Xobject.present_p(str)) {
      av = str.split(/\s+/)
    }
    return av
  },

  // str_to_tags("a,b,a") // => ["a", "b"]
  str_to_tags(str) {
    return _.uniq(this.str_to_words(str))
  },

  // tags_str_toggle("a b", "c")   //=> "a b c"
  // tags_str_toggle("a b c", "c") //=> "a b"
  tags_str_toggle(keywords_str, str) {
    let av = this.str_to_tags(keywords_str)
    if (av.includes(str)) {
      _.pull(av, str)
    } else {
      av.push(str)
    }
    return av.join(" ")
  },

  // str_truncate("hello", {length: 20})
  str_truncate(str, options = {}) {
    return _.truncate(str, {omission: "...", length: 80, ...options})
  },

  // 文字列の文字のコードの合計
  str_to_hash_number(str) {
    return _.sumBy([...str], e => e.codePointAt(0))
  },
}
