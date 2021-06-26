import _ from "lodash"

export class HandleNameParser {
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
    s = s.replace(/(.+)[@＠].*/, "$1") // "alice@xxx"      → "alice"
    s = s.replace(/[。]/g, "")         // "name。"         → "name"
    s = s.replace(/(.+)\(.*\)$/, "$1") // "name123(xxx)"   → "name123"
    s = s.replace(/(.+)（.*）$/, "$1") // "name123（xxx）" → "name123"
    s = s.replace(/(\D+)\d+$/, "$1")   // "name123"        → "name"
    if (s.match(/.(ん|ン|ﾝ|さま|サマ|ｻﾏ|様|氏|段|級|団|冠)[!！]?$/)) {
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
