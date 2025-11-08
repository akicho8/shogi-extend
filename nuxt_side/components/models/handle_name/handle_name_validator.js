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
import { GX } from "@/components/models/gx.js"
import { HandleNameNgWordList } from "./handle_name_ng_word_list.js"
import { SystemNgWordList } from "@/components/models/system_ng_word_list.js"

export class HandleNameValidator {
  static MAX_LENGTH = 10

  static PREFIX_LIST = [
    "もっと素敵な",
    // "真面目に",
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

    const name = this.normalized_name
    if (message == null) {
      if (GX.blank_p(name)) {
        message = `${this.options.name}を入力してください`
      }
    }

    if (this.options.ng_word_check_p) {
      if (message == null) {
        // 許可する文字：英数字、ひらがな、カタカナ、漢字
        if (!name.match(/^[a-zA-Z0-9\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF]+$/)) {
          message = this.message_sample
        }
      }
      if (message == null) {
        // 「漢字を除いた文字列」を作成
        const without_kanji = name.replace(/[一-龥]/g, "")
        // 「漢字を除いたときに1文字だけ」ならNG（例：'あ' や 'A' はNG）
        const is_single_non_kanji = without_kanji.length === 1
        if (is_single_non_kanji) {
          message = this.message_sample
        }
      }
      if (message == null) {
        // 「もっと素敵な」を弾く
        if (name.match(new RegExp(this.constructor.PREFIX_LIST.join("|"), "i"))) {
          message = this.message_sample
        }
      }
      if (message == null) {
        // 「通りすがり」
        if (name.match(new RegExp(HandleNameNgWordList.join("|"), "i"))) {
          message = this.message_sample
        }
      }
    }

    return message
  }

  // private

  get normalized_name() {
    let name = this.source
    name = GX.str_control_chars_remove(name)
    name = GX.str_space_remove(name)
    name = GX.hankaku_format(name)    // バリデーションしやすくするため
    return name
  }

  get message_sample() {
    const pepper = dayjs().format("YYYY-MM-DD")
    const hash_number = GX.str_to_hash_number([pepper, this.source].join("-"))
    const prefix = GX.ary_cycle_at(this.constructor.PREFIX_LIST, hash_number)
    return `${prefix}${this.options.name}を入力してください`
  }
}
