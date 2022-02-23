import _ from "lodash"

export class HandleNameParser {
  static DELETE_SUFFIX_CHARS = "!！."   // 最後にあると削除する文字たち
  // static DELETE_SUFFIX_WORD  = "chan"   // 最後にあると削除する単語たち
  static DELETE_CHAR         = "。"     // どこにあっても削除する文字たち

  // call_name("SOS団")             → "SOS団"
  // call_name("ありす")            → "ありすさん"
  // call_name("ありす123(居飛車)") → "ありすさん"
  static call_name(s, options = {}) {
    return this.parse(s, options).call_name
  }

  static parse(s, options = {}) {
    return new this(s, options)
  }

  constructor(s, options = {}) {
    this.source = s ?? ""
    this.options = options
  }

  get call_name() {
    let s = _.trim(this.source)
    s = s.replace(/(.+)[@＠].*/, "$1")                                            // "alice@xxx"       → "alice"
    s = s.replace(new RegExp(`(.+?)[${this.constructor.DELETE_SUFFIX_CHARS}]+$`), "$1") // "alice!"          → "alice"
    // s = s.replace(new RegExp(`(.+?)(${this.constructor.DELETE_SUFFIX_WORD.join('|')})$`), "$1") // "alice!"          → "alice"
    s = s.replace(new RegExp(`[${this.constructor.DELETE_CHAR}]`, "g"), "")       // "alice。"         → "alice"
    s = s.replace(/(.+)\(.*\)$/, "$1")                                            // "alice123(xxx)"   → "alice123"
    s = s.replace(/(.+)（.*）$/, "$1")                                            // "alice123（xxx）" → "alice123"
    s = s.replace(/(\D+)\d+$/, "$1")                                              // "alice123"        → "alice"

    if (s.match(/.(ん|ン|ﾝ|さま|サマ|ｻﾏ|様|氏|段|級|団|冠|人|chan)$/)) {
      return s
    }

    if (s.match(/.(コ|ｺ|こ|子|ko|co)$/i)) {
      return `${s}ちゃん`
    }

    if (s.match(/.(王)$/)) { // "女王" → "女王様"
      return `${s}様`
    }

    return `${s}さん`
  }
}
