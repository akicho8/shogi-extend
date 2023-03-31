// import { HandleNameValidator } from '@/components/models/handle_name/handle_name_validator.js'
//
// const handle_name_validator = HandleNameValidator.create(str, {name: "名前"})
// const message = handle_name_validator.valid_message
// if (message) {
//   this.toast_warn(message)
//   return
// }
//

import _ from "lodash"
import dayjs from "dayjs"
import { Gs } from "@/components/models/gs.js"
import { parse as TwitterEmojiParser } from "twemoji-parser"
import { HandleNameNgWordList } from "./handle_name_ng_word_list.js"

export class HandleNameValidator {
  static MAX_LENGTH = 16

  static PREFIX_LIST = [
    "素敵な",
    "友好的な",
    "真面目に",
    "親近感のある",
    "フレンドリーな",
    "親しみのある",
    "捨てハンでない",
  ]

  static create(source, options = {}) {
    return new this(source, options)
  }

  static valid_message(source, options = {}) {
    return this.create(source, options).valid_message
  }

  static valid_p(source, options = {}) {
    return this.create(source, options).valid_p
  }

  static invalid_p(source, options = {}) {
    return this.create(source, options).invalid_p
  }

  constructor(source, options) {
    this.source = source
    this.options = {
      name: "ハンドルネーム",
      ...options,
    }
  }

  get valid_p() {
    return this.valid_message == null
  }

  get invalid_p() {
    return !this.valid_p
  }

  get valid_message() {
    let s = this.normalized_source

    let message = null
    if (message == null) {
      if (Gs.blank_p(s)) {
        message = `${this.options.name}を入力してください`
      }
    }
    if (message == null) {
      if (s.length > this.MAX_LENGTH) {
        message = `${this.options.name}は${this.MAX_LENGTH}文字以下にしてください`
      }
    }
    if (message == null) {
      if (s.match(new RegExp(this.constructor.PREFIX_LIST.join("|"), "i"))) { // 素敵な○○
        message = this.message_sample
      }
    }
    if (message == null) {
      if (s.match(new RegExp(HandleNameNgWordList.join("|"), "i"))) {  // 通りすがり
        message = this.message_sample
      }
    }
    if (message == null) {
      if (s.length <= 1 && !s.match(/[一-龠]/)) { // 1文字のひらがな
        message = this.message_sample
      }
    }
    if (message == null) {
      if ([...s].length === TwitterEmojiParser(s).length) { // すべて絵文字
        message = `${this.options.name}には絵文字以外も入力してください`
      }
    }
    return message
  }

  // private

  get normalized_source() {
    let s = this.source
    s = Gs.str_space_remove(s)
    s = s.replace(/[\.・]/g, "")      // ノイズ文字を取る
    s = Gs.hankaku_format(s)
    return s
  }

  get message_sample() {
    const pepper = dayjs().format("YYYY-MM-DD")
    const hash_number = Gs.str_to_hash_number([pepper, this.source].join("-"))
    const prefix = Gs.ary_cycle_at(this.constructor.PREFIX_LIST, hash_number)
    return `${prefix}${this.options.name}を入力してください`
  }
}
