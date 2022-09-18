import { Gs2 } from "../../../models/gs2.js"

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

  get self_vs_self_p() { return this.user_total_count.length === 1 } // 自分vs自分で対戦している？
  get one_vs_one_p()   { return this.user_total_count.length === 2 } // 1vs1で対戦している？
  get many_vs_many_p() { return this.user_total_count.length >= 3  } // 3人以上で対戦している？

  // turn 0 から開始したときのユーザーたち
  real_order_users(tegoto, kaisi) {
    return Gs2.n_times_collect(this.round_size * tegoto, i => {
      return this.current_user_by_turn(i, tegoto, kaisi)
    })
  }

  first_user(kaisi) {
    return this.current_user_by_turn(0, 1, kaisi)
  }
}
