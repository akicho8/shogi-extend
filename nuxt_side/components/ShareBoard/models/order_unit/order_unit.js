import { O1State } from "./o1_state.js"
import { O2State } from "./o2_state.js"
import { Gs2 } from "../../../models/gs2.js"
import _ from "lodash"

export class OrderUnit {
  static from_attributes(attributes) {
    const object = new this()
    object.attributes = attributes
    return object
  }

  // 流し込み
  static create(...args) {
    const object = new this()
    object.reset_by_users(...args)
    return object
  }

  constructor() {
    this.order_state = new O2State()
    this.member_other = []
  }

  reset_by_users(...args) {
    this.order_state.reset_by_users(...args)
  }

  sample_set() {
    this.order_state.reset_by_users(["a", "b", "c", "d", "e"])
  }

  shuffle_core() {
    this.order_state.shuffle_core()
  }

  furigoma_core(swap_flag) {
    if (swap_flag) {
      this.swap_exec()
    }
  }

  swap_exec() {
    this.order_state.swap_exec()
  }

  clear() {
    this.order_state.reset_by_users([])
    this.member_other = []
  }

  current_user_by_turn(turn, tegoto, kaisi) {
    return this.order_state.current_user_by_turn(turn, tegoto, kaisi)
  }

  state_change_handle(method) {
    this.order_state = this.order_state[method]
  }

  get state_name() {
    return this.order_state.constructor.name
  }

  get attributes() {
    return {
      member_other: this.member_other,
      order_state: this.order_state.attributes,
    }
  }
  set attributes(v) {
    this.member_other = v.member_other
    const klass = Gs2.str_constantize(v.order_state.class_name)
    const order_state = new klass()
    order_state.attributes = v.order_state
    this.order_state = order_state
  }

  clone() {
    const object = new this.constructor()
    object.attributes = this.attributes
    return object
  }

  dump_and_load() {
    this.attributes = this.attributes
  }

  get self_vs_self_p()   { return this.order_state.self_vs_self_p }
  get one_vs_one_p()     { return this.order_state.one_vs_one_p }
  get many_vs_many_p()   { return this.order_state.many_vs_many_p }
  get user_total_count() { return this.order_state.user_total_count }

  get black_start_order_uniq_users() {
    return this.order_state.black_start_order_uniq_users
  }

  first_user(kaisi) {
    return this.order_state.first_user(kaisi)
  }

  real_order_users(tegoto, kaisi) {
    return this.order_state.real_order_users(tegoto, kaisi)
  }

  get flat_uniq_users() {
    return this.order_state.flat_uniq_users
  }

  get round_size() {
    return this.order_state.round_size
  }

  // 名前から順番を知るためのハッシュ
  omember_names_hash(kaisi) {
    // return this.order_unit.real_order_users(this.tegoto, this.kaisi).reduce((a, e) => ({...a, [e.user_name]: e}), {})
    const users = this.real_order_users(1, kaisi)
    let index = 0
    const acc = users.reduce((a, e) => {
      if (e.user_name in a) {
      } else {
        a[e.user_name] = index
        index += 1
      }
      return a
    }, {})
    return acc            // => { alice: 2, bob: 1 }
    // return this.order_unit.real_order_users(this.tegoto, this.kaisi).reduce((a, e) => ({...a, [e.user_name]: e}), {})
  }
}
