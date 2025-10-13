import _ from "lodash"
import NodeEmoji from "node-emoji"
import { GX } from "@/components/models/gx.js"

const CLEAN_TRY_COUNT = 2

export class HandleNameParser {
  static DELETE_SUFFIX_CHARS = "!！.／-"        // 最後にあると削除する文字たち
  static DELETE_SUFFIX_WORD  = ["だよ", "です"] // 最後にあると削除する単語たち
  static DELETE_CHAR         = "。"             // どこにあっても削除する文字たち

  // call_name("SOS団")             → "SOS団"
  // call_name("ありす")            → "ありすさん"
  // call_name("ありす123(居飛車)") → "ありすさん"
  static call_name(source, options = {}) {
    return this.parse(source, options).call_name
  }

  static parse(source, options = {}) {
    return new this(source, options)
  }

  constructor(source, options = {}) {
    GX.assert(GX.present_p(source), "this.$GX.present_p(source) in HandleNameParser")
    this.source = source
    this.options = options
  }

  get call_name() {
    let s = this.source

    // 1度やればよい洗浄
    s = _.trim(s)
    s = this.safe_emoji_strip(s)
    s = s.replace(/(.+)[@＠].*/, "$1")                                                          // "alice@xxx"       → "alice"
    s = s.replace(new RegExp(`[${this.constructor.DELETE_CHAR}]`, "g"), "")                     // "ali。ce"         → "alice"

    // 削除したい文字が連続する場合があるため数回洗浄する
    GX.n_times(CLEAN_TRY_COUNT, () => {
      s = s.replace(new RegExp(`(.+?)[${this.constructor.DELETE_SUFFIX_CHARS}]+$`), "$1")         // "alice!"          → "alice"
      s = s.replace(new RegExp(`(.+?)(${this.constructor.DELETE_SUFFIX_WORD.join('|')})$`), "$1") // "aliceだよ"       → "alice"
      s = s.replace(/(.+)\(.*\)$/, "$1")                                                          // "alice123(xxx)"   → "alice123"
      s = s.replace(/(.+)（.*）$/, "$1")                                                          // "alice123（xxx）" → "alice123"
      s = s.replace(/(\D+)\d+$/, "$1")                                                            // "alice123"        → "alice"
    })

    if (s.match(/.(さま|サマ|ｻﾏ|様|氏|段|級|団|冠|人|民|chan|kun)$/i)) {
      return s
    }

    // |------------+------------|
    // | ○ん       | ○んさん   |
    // | ○○ん     | ○○んさん |
    // | ○○○ん   | ○○○ん   |
    // | ○○○○ん | ○○○○ん |
    // |------------+------------|
    if (s.match(/^.{3,}(ん|ン|ﾝ|ー)$/)) {
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

  // private

  // 絵文字を除去する
  // ただし除去して空になるなら除去しない
  safe_emoji_strip(str) {
    let s = str
    s = NodeEmoji.strip(s)
    s = _.trim(s)
    if (s === "") {
      s = str
    }
    return s
  }
}
