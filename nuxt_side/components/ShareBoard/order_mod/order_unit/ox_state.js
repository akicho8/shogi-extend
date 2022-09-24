// O1State, O2State の共通部分

import { Gs2 } from "@/components/models/gs2.js"
const MD5 = require("md5.js")

export class OxState {
  static create_by_users(users) {
    const object = new this()
    object.users_allocate(users)
    Object.freeze(object)
    return object
  }

  get class_name() {
    return this.constructor.name
  }

  get attributes() {
    return {
      class_name: this.class_name,
    }
  }

  // turn 0 から開始したときのユーザーたち
  // null を含む
  real_order_users(tegoto, scolor) {
    return Gs2.n_times_collect(this.round_size * tegoto, i => {
      return this.turn_to_item(i, tegoto, scolor)
    })
  }

  // 1手毎としたときの約一周したときの名前を順番に並べた文字列
  real_order_users_to_s(tegoto, scolor) {
    return this.real_order_users(tegoto, scolor).map(e => e ? e.to_s : "?").join("")
  }

  // 差分確認用のハッシュ
  get hash() {
    const str = this.real_order_users(1, 0).map(e => e ? e.to_s : "?").join(",")
    return new MD5().update(str).digest("hex")
  }

  // kaisi色から開始したときの0手目の人を返す
  first_user(scolor) {
    return this.turn_to_item(0, 1, scolor)
  }

  // 準備できたか？
  get error_messages() {
    const messages = []
    if (this.empty_p) {
      messages.push(`誰も参加していません`)
    }
    return messages
  }

  get empty_p()        { return this.main_user_count === 0 } // 対戦者がいない？
  get self_vs_self_p() { return this.main_user_count === 1 } // 自分vs自分で対戦している？ (または相手がいない)
  get one_vs_one_p()   { return this.main_user_count === 2 } // 1vs1で対戦している？
  get many_vs_many_p() { return this.main_user_count >= 3  } // 3人以上で対戦している？
}
