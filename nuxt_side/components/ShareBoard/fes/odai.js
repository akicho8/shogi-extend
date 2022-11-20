import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

export class Odai {
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

  // すべて入力されているか？
  get valid_p() {
    return [this.subject, ...this.items].every(e => Gs2.present_p(e))
  }

  // どれかがまだ入力されていない？
  get invalid_p() {
    return !this.valid_p
  }

  // 内容のハッシュ
  // 入力前の状態と初期化した状態が同じハッシュになってしまうため使いづらい
  get content_hash() {
    return Gs2.str_to_md5([this.subject, ...this.items].join("/"))
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
    return Gs2.blank_p(this.subject) && this.items.every(e => Gs2.blank_p(e))
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
}
