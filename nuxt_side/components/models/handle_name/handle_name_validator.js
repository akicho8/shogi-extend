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
import { RegexpSet } from "@/components/models/regexp_set.js"
import { HandleNameNgWordList } from "./handle_name_ng_word_list.js"
import { HandleNameNormalizer } from "./handle_name_normalizer.js"
import { SystemNgWordList } from "@/components/models/system_ng_word_list.js"

export class HandleNameValidator {
  static MAX_LENGTH = 10

  static NG_PREFIX_LIST = [
    "もっと素敵な",
    "真面目に",
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
      // 絵文字とか使うな
      if (message == null) {
        if (!name.match(RegexpSet.HANDLE_NAME_SAFE_CHAR)) {
          message = `使用できない文字が含まれています`
        }
      }

      // 1文字にするな
      if (message == null) {
        // 「漢字を除いた文字列」を作成
        const without_kanji = name.replace(/[一-龥]/g, "")
        // 「漢字を除いたときに1文字だけ」ならNG（例：'あ' や 'A' はNG）
        const is_single_non_kanji = without_kanji.length === 1
        if (is_single_non_kanji) {
          message = `もう少しユニークな${this.options.name}を入力してください`
        }
      }

      // 全部数字は名前じゃない
      if (message == null) {
        // 全体が「全角数字」「半角数字」で構成されているものはダメ
        if (name.match(RegexpSet.COMMON_NUMBER)) {
          message = `それはただの数字です`
        }
      }

      // 段級位を書くな
      if (message == null) {
        if (name.match(RegexpSet.COMMON_GRADE)) {
          message = `段級位を含めないでください`
        }
      }

      // 「もっと素敵な」や「真面目に」を弾く (エラー文言に合わせて必ずこれを入力するやつがいる)
      if (message == null) {
        if (name.match(new RegExp(this.constructor.NG_PREFIX_LIST.join("|"), "i"))) {
          message = `真面目に入力してください`
        }
      }

      // 卑猥な用語を入れるやつを弾く
      if (message == null) {
        if (name.match(new RegExp(HandleNameNgWordList.join("|"), "i"))) {
          message = `もっと素敵な${this.options.name}を入力してください`
        }
      }
    }

    return message
  }

  // private

  get normalized_name() {
    return HandleNameNormalizer.normalize(this.source)
  }
}
