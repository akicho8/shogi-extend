// import { RoomKeyValidator } from 'room_key_validator.js'
//
// const room_key_validator = RoomKeyValidator.create(str, {name: "名前"})
// const message = room_key_validator.valid_message
// if (message) {
//   this.toast_warn(message)
//   return
// }
//

import _ from "lodash"
import dayjs from "dayjs"
import { GX } from "@/components/models/gx.js"
import { RegexpSet } from "@/components/models/regexp_set.js"
import { SystemNgWordList } from "@/components/models/system_ng_word_list.js"

export class RoomKeyValidator {
  static MAX_LENGTH = 32

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
      name: "合言葉",
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
    const s = this.normalized_source
    let message = null
    if (message == null) {
      if (GX.blank_p(s)) {
        message = `${this.options.name}を入力してください`
      }
    }
    if (message == null) {
      if (this.options.max_length) {
        if (s.length > this.options.max_length) {
          message = `${this.options.name}は${this.options.max_length}文字以内にしてください`
        }
      }
    }
    if (message == null) {
      if (!s.match(RegexpSet.ROOM_KEY_SAFE_CHAR)) {
        message = `${this.options.name}に使えない文字が含まれています`
      }
    }
    return message
  }

  // private

  get normalized_source() {
    return this.source ?? ""
  }
}
