import _ from "lodash"
import { Gs } from "@/components/models/gs.js"
import { MessageNgWordList } from "./message_ng_word_list.js"

export class MessageValidator {
  static create(source, options = {}) {
    return new this(source, options)
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
      ...options,
    }
  }

  get valid_p() {
    return !this.invalid_p
  }

  get invalid_p() {
    let s = this.normalized_source
    if (s.match(new RegExp(MessageNgWordList.join("|"), "i"))) {
      return true
    }
    return false
  }

  // private

  get normalized_source() {
    let s = this.source
    s = Gs.str_space_remove(s)
    // s = s.replace(/[\.・]/g, "")      // ノイズ文字を取る
    s = Gs.hankaku_format(s)
    return s
  }
}
