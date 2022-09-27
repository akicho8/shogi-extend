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

  constructor() {
    this.memo = {}
  }

  cache_clear() {
    this.memo = {}
  }

  memoize(key, block) {
    if (key in this.memo) {
      return this.memo[key]
    }
    this.memo[key] = block()
    return this.memo[key]
  }

  get state_name() {
    // return this.constructor.name とするとビルド時に名前が代わる
    alert("class_name is not implemented")
  }

  get attributes() {
    return {
      state_name: this.state_name,
    }
  }

  // turn 0 から開始したときのユーザーたち
  // null を含む
  real_order_users(tegoto, scolor) {
    return this.memoize(`real_order_users/${tegoto}/${scolor}`, () => {
      return Gs2.n_times_collect(this.round_size * tegoto, i => {
        return this.turn_to_item(i, tegoto, scolor)
      })
    })
  }

  // 1手毎としたときの約一周したときの名前を順番に並べた文字列
  real_order_users_to_s(tegoto, scolor) {
    return this.real_order_users(tegoto, scolor).map(e => e ? e.to_s : "?").join("")
  }

  // 名前から順番を知るためのハッシュ
  // a b
  //   c
  // で黒から始める場合 { a: [0, 2], b: [1], c:[3] }
  // で白から始める場合 { a: [1, 3], b: [0], c:[2] }
  name_to_turns_hash(scolor) {
    return this.memoize(`name_to_turns_hash/${scolor}`, () => {
      const users = this.real_order_users(1, scolor)
      return users.reduce((a, e, i) => {
        if (e) {
          if (a[e.user_name] == null) {
            a[e.user_name] = []
          }
          a[e.user_name].push(i)
        }
        return a
      }, {})
    })
  }

  // 名前からユーザーを引くためのハッシュ
  // => { alice: <Item>, bob: <Item> }
  get name_to_object_hash() {
    return this.memoize("name_to_object_hash", () => {
      return this.flat_uniq_users.reduce((a, e) => ({...a, [e.user_name]: e}), {})
    })
  }

  // 差分確認用のハッシュ
  get hash() {
    const users_str = this.real_order_users(1, 0).map(e => e ? e.to_s : "?").join(",")
    const all = [this.state_name, users_str].join(":")
    return new MD5().update(all).digest("hex")
  }

  // scolor色から開始したときの0手目の人を返す
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
