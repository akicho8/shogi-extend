import { Gs2 } from "@/components/models/gs2.js"

export class OxState {
  static create_by_users(...args) {
    const object = new this()
    object.reset_by_users(...args)
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

  get self_vs_self_p() { return this.main_user_count.length === 1 } // 自分vs自分で対戦している？
  get one_vs_one_p()   { return this.main_user_count.length === 2 } // 1vs1で対戦している？
  get many_vs_many_p() { return this.main_user_count.length >= 3  } // 3人以上で対戦している？

  // turn 0 から開始したときのユーザーたち
  // null を含む
  real_order_users(tegoto, kaisi) {
    return Gs2.n_times_collect(this.round_size * tegoto, i => {
      return this.current_user_by_turn(i, tegoto, kaisi)
    })
  }

  // kaisi色から開始したときの0手目の人を返す
  first_user(kaisi) {
    return this.current_user_by_turn(0, 1, kaisi)
  }

  // 準備できたか？
  get error_messages() {
    const messages = []
    if (this.main_user_count === 0) {
      messages.push(`誰も参加していません`)
    }
    return messages
  }
}
