// このなかで watch_users を管理するべきか考える

import { O1State } from "./o1_state.js"
import { O2State } from "./o2_state.js"
import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

export class OrderUnit {
  static from_attributes(attributes) {
    const object = new this()
    object.attributes = attributes
    return object
  }

  // 流し込み
  static create(users = []) {
    const object = new this()
    object.reset_by_users(users)
    return object
  }

  constructor() {
    this.order_state = new O2State()
    this.watch_users = []
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
      this.swap_run()
    }
  }

  swap_run() {
    this.order_state.swap_run()
  }

  clear() {
    this.order_state.reset_by_users([])
    this.watch_users = []
  }

  turn_to_user_object(turn, tegoto, kaisi) {
    return this.order_state.turn_to_user_object(turn, tegoto, kaisi)
  }

  state_change_handle(method) {
    this.order_state = this.order_state[method]
  }

  get state_name() {
    return this.order_state.constructor.name
  }

  get attributes() {
    return {
      watch_users: this.watch_users,
      order_state: this.order_state.attributes,
    }
  }
  set attributes(v) {
    this.watch_users = v.watch_users
    const klass = Gs2.str_constantize(v.order_state.class_name)
    const order_state = new klass()
    order_state.attributes = v.order_state
    this.order_state = order_state
  }

  // これを使って new_v.order_unit を作っている
  deep_clone() {
    const object = new this.constructor()
    object.attributes = this.attributes // 内部は同じものを見ているので危険
    return _.cloneDeep(object)          // 別のものにしないと new_v.order_unit が order_unit に即反映されてしまう
  }

  dump_and_load() {
    this.attributes = this.attributes
  }

  get self_vs_self_p()   { return this.order_state.self_vs_self_p }
  get one_vs_one_p()     { return this.order_state.one_vs_one_p }
  get many_vs_many_p()   { return this.order_state.many_vs_many_p }
  get main_user_count() { return this.order_state.main_user_count }

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
  // a b
  //   c
  // だった場合 { a: [0, 2], b: [1], c:[3] }
  name_to_turns_hash(kaisi) {
    const users = this.real_order_users(1, kaisi)
    let index = 0
    return users.reduce((a, e) => {
      if (a[e.user_name] == null) {
        a[e.user_name] = []
      }
      a[e.user_name].push(index)
      index += 1
      return a
    }, {})
  }

  // 名前からユーザーを引くハッシュ
  // => { alice: {...}, bob: {...} }
  get name_to_object_hash() {
    return this.flat_uniq_users.reduce((a, e) => {
      a[e.user_name] = e
      return a
    }, {})
  }

  // 先後入れ替えできるか？
  get irekae_can_p() {
    return this.order_state.irekae_can_p
  }

  get error_messages() {
    return this.order_state.error_messages
  }

  get valid_p() {
    return Gs2.blank_p(this.order_state.error_messages)
  }

  get invalid_p() {
    return !this.valid_p
  }

  get inspect() {
    const list0 = this.real_order_users(1, 0).map(e => e ? e.user_name : "?").join("")
    const list1 = this.real_order_users(1, 1).map(e => e ? e.user_name : "?").join("")
    const wlist = this.watch_users.map(e => e.user_name).join(",")
    return `[黒開始:${list0}] [白開始:${list1}] [観:${wlist}] [整:${this.valid_p}] [替:${this.irekae_can_p}] (${this.state_name})`
  }

  // 観戦者を含めて指定の名前はこの中に存在するか？
  user_name_exist_p(user_name) {
    const users = [...this.flat_uniq_users, ...this.watch_users]
    return users.some(e => e.user_name === user_name)
  }

  // 観戦者の追加
  watch_users_add(user_names) {
    user_names.forEach(user_name => {
      if (!this.user_name_exist_p(user_name)) {
        this.watch_users.push({user_name: user_name})
      }
    })
  }

  state_toggle() {
    if (this.order_state.constructor.name === "O1State") {
      this.state_change_handle("to_o2_state")
    } else {
      this.state_change_handle("to_o1_state")
    }
  }
}
