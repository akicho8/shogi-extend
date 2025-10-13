import { Gs } from "@/components/models/gs.js"
import _ from "lodash"
import Vue from "vue"

export class Quiz {
  // 開発時用
  static get sample() {
    return this.create({subject: "どっちがお好き？", items: ["マヨネーズ", "ケチャップ"]})
  }

  // Value Object にしたいが v-model に渡している関係でできない
  static create(...args) {
    return new this(...args)
  }

  constructor(params = {}) {
    this.unique_code = params.unique_code ?? _.uniqueId()
    this.subject     = params.subject ?? ""
    this.items       = params.items ?? ["", ""]
  }

  // 一行の文章にする
  get to_s() {
    return [
      Gs.presence(this.subject) ?? "どっちが好き？",
      "？",
      this.items.map(e => `${e}`).join("または"),
      "。",                     // 後ろに繋げる場合があるので読点を入れておく
    ].join("")
  }

  // すべて入力されているか？
  get valid_p() {
    return [this.subject, ...this.items].every(e => Gs.present_p(e))
  }

  // どれかがまだ入力されていない？
  get invalid_p() {
    return !this.valid_p
  }

  // 内容のハッシュ
  // 入力前の状態と初期化した状態が同じハッシュになってしまうため使いづらい
  get content_hash() {
    return Gs.str_to_md5([this.subject, ...this.items].join("/"))
  }

  // コンテンツの内容が同じか？ (再送信の表示に使いたい)
  same_content_p(other) {
    if (true) {
      return this.content_hash === other.content_hash
    } else {
      // これはメソッドの名前と内容が異なるため使用禁止
      // データが空かどうかで条件が変わるとは予測つかない
      if (!this.empty_p && !other.empty_p) {
        return this.content_hash === other.content_hash
      }
    }
  }

  // すべて空？ (つまり初期値の状態？)
  get empty_p() {
    return Gs.blank_p(this.subject) && this.items.every(e => Gs.blank_p(e))
  }

  get attributes() {
    return {
      unique_code: this.unique_code,
      subject: this.subject,
      items: this.items,
    }
  }

  // ActionCable で送る際にこれを呼んでくれるっぽい
  toJSON() {
    return this.attributes
  }

  // unique_code を除いて内容をコピーしたものを返す
  dup() {
    return this.constructor.create({
      subject: this.subject,
      items: this.items,
    })
  }

  // フォームでマジックナンバーを書きたくないのでエイリアス的なアクセサを用意した
  set left_value(value) { Vue.set(this.items, 0, value) }
  get left_value()      { return this.items[0]          }
  set right_value(value) { Vue.set(this.items, 1, value) }
  get right_value()      { return this.items[1]          }
}
