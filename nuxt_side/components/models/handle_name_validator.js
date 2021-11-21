import _ from "lodash"
import dayjs from "dayjs"
import { Gs } from "./gs.js"
import { parse as TwitterEmojiParser } from "twemoji-parser"
import { HandleNameNgWordList } from "./handle_name_ng_word_list.js"

export const HandleNameValidator = {
  get MAX_LENGTH() { return 16 },

  // import { HandleNameValidator } from '@/components/models/handle_name_validator.js'
  //
  // const message = HandleNameValidator.valid_with_message(str, {name: "名前"})
  // if (message) {
  //   this.toast_warn(message)
  //   return
  // }
  //
  valid_with_message(s, options = {}) {
    options = {
      name: "ハンドルネーム",
      ...options,
    }
    s = _.trim(s)
    if (s.length === 0) {
      return `${options.name}を入力してください`
    }
    if (s.length > this.MAX_LENGTH) {
      return `${options.name}が長すぎます`
    }
    if (this.valid(s)) {
      return null
    } else {
      const pepper = dayjs().format("YYYY-MM-DD")
      const hash_number = Gs.hash_number_from_str([pepper, s].join("-"))
      const prefix = Gs.ary_cycle_at(this.prefix_list, hash_number)
      return `${prefix}${options.name}を入力してください`
    }
  },
  valid(s) {
    s = s.replace(/[\s\u3000]+/g, "") // 空白を取る
    s = s.replace(/[\.・]/g, "")      // ノイズ文字を取る
    s = Gs.hankaku_format(s)          // 半角化
    let error = false
    if (!error) {
      error = (s.length === 0)
    }
    if (!error) {
      error = (s.length > this.MAX_LENGTH)
    }
    if (!error) {
      error = s.match(new RegExp(this.prefix_list.join("|"), "i")) // 素敵な○○
    }
    if (!error) {
      error = s.match(new RegExp(HandleNameNgWordList.join("|"), "i")) // 通りすがり
    }
    if (!error) {
      error = (s.length <= 1 && !s.match(/[一-龠]/)) // 1文字のひらがな
    }
    if (!error) {
      error = [...s].length === TwitterEmojiParser(s).length // すべて絵文字
    }
    return !error
  },
  get prefix_list() {
    return [
      "素敵な",
      "友好的な",
      "真面目に",
      "親近感のある",
      "フレンドリーな",
      "親しみのある",
      "捨てハンでない",
    ]
  },
}
