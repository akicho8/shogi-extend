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
import { GX } from "@/components/models/gs.js"
import { parse as TwitterEmojiParser } from "twemoji-parser"
import { HandleNameNgWordList } from "./handle_name_ng_word_list.js"
import { SystemNgWordList } from "@/components/models/system_ng_word_list.js"

export class HandleNameValidator {
  static MAX_LENGTH = 10

  static PREFIX_LIST = [
    "もっと素敵な",
    "真面目に",
    // "友好的な",
    // "親近感のある",
    // "フレンドリーな",
    // "親しみのある",
    // "捨てハンでない",
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
      ng_word_check_p: true,
      max_length: this.constructor.MAX_LENGTH,
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
    let message = null

    if (message == null) {
      if (this.options.max_length) {
        if (this.source.length > this.options.max_length) {
          message = `${this.options.name}は${this.options.max_length}文字以内にしてください`
        }
      }
    }

    let s = this.normalized_source
    if (message == null) {
      if (GX.blank_p(s)) {
        message = `${this.options.name}を入力してください`
      }
    }

    if (this.options.ng_word_check_p) {
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
        if (s.match(new RegExp(SystemNgWordList.join("|"), "i"))) {  // URLとして使えない文字
          message = `${this.options.name}には記号のような文字を含めないでください`
        }
      }
      if (message == null) {
        if (s.length <= 1 && !s.match(/[一-龠]/)) { // 漢字を除く、1文字はだめ
          message = this.message_sample
        }
      }
      if (message == null) {
        if ([...s].length === TwitterEmojiParser(s).length) { // すべて絵文字
          message = `${this.options.name}には絵文字以外も入力してください`
        }
      }
    }

    return message
  }

  // private

  get normalized_source() {
    let s = this.source
    s = GX.str_control_chars_remove(s)
    s = GX.str_space_remove(s)
    s = GX.hankaku_format(s)    // バリデーションしやすくするため
    return s
  }

  get message_sample() {
    const pepper = dayjs().format("YYYY-MM-DD")
    const hash_number = GX.str_to_hash_number([pepper, this.source].join("-"))
    const prefix = GX.ary_cycle_at(this.constructor.PREFIX_LIST, hash_number)
    return `${prefix}${this.options.name}を入力してください`
  }
}
