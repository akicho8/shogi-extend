// このなかで watch_users を管理するべきか考える

import { O1State } from "./o1_state.js"
import { O2State } from "./o2_state.js"
import { Item } from "./item.js"
import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

export class OrderUnit {
  static from_attributes(attributes) {
    const object = new this()
    object.attributes = attributes
    return object
  }

  // 流し込み
  static create(user_names = []) {
    const object = new this()
    object.user_names_allocate(user_names)
    return object
  }

  constructor() {
    this.order_state = new O2State()
    this.watch_users = []
  }

  user_names_allocate(user_names) {
    const users = user_names.map(user_name => Item.create(user_name))
    this.order_state.users_allocate(users)
  }

  users_allocate(users) {
    this.order_state.users_allocate(users)
  }

  sample_set() {
    this.user_names_allocate(["a", "b", "c", "d", "e"])
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
    this.order_state.users_allocate([])
    this.watch_users = []
  }

  turn_to_item(turn, tegoto, kaisi) {
    return this.order_state.turn_to_item(turn, tegoto, kaisi)
  }

  state_change_handle(method) {
    Gs2.__assert__(this.order_state[method], "this.order_state[method]")
    this.order_state = this.order_state[method]
  }

  get state_name() {
    return this.order_state.constructor.name
  }

  // 観戦者は含まないでよい
  get attributes() {
    // return {
    //   // watch_users: this.watch_users,
    //   // order_state: this.order_state.attributes,
    // }
    return this.order_state.attributes
  }
  set attributes(v) {
    // this.watch_users = v.watch_users
    const klass = Gs2.str_constantize(v.class_name)
    const order_state = new klass()
    order_state.attributes = v
    this.order_state = order_state
  }

  // これを使って new_v.order_unit を作っている
  deep_clone() {
    const object = new this.constructor()
    object.attributes = this.attributes // 内部は同じものを見ているので危険
    return _.cloneDeep(object)          // 別のものにしないと new_v.order_unit が order_unit に即反映されてしまう
  }

  dump_and_load() {
    const json = JSON.parse(JSON.stringify(this.attributes))
    this.clear()
    this.attributes = json
  }

  get self_vs_self_p()   { return this.order_state.self_vs_self_p }
  get one_vs_one_p()     { return this.order_state.one_vs_one_p }
  get many_vs_many_p()   { return this.order_state.many_vs_many_p }
  get main_user_count()  { return this.order_state.main_user_count }

  get black_start_order_uniq_users() {
    return this.order_state.black_start_order_uniq_users
  }

  first_user(kaisi) {
    return this.order_state.first_user(kaisi)
  }

  real_order_users(tegoto, kaisi) {
    return this.order_state.real_order_users(tegoto, kaisi)
  }

  // デバッグ用
  real_order_users2(tegoto, kaisi) {
    return this.order_state.real_order_users2(tegoto, kaisi)
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
    const list0 = this.real_order_users(1, 0).map(e => e ? e.to_s : "?").join("")
    const list1 = this.real_order_users(1, 1).map(e => e ? e.to_s : "?").join("")
    const wlist = this.watch_users.map(e => e.to_s).join(",")
    return `[黒開始:${list0}] [白開始:${list1}] [観:${wlist}] [整:${this.valid_p}] [替:${this.irekae_can_p ? 'o' : 'x'}] (${this.state_name})`
  }

  // 観戦者を含めて指定の名前はこの中に存在するか？
  // user_name_exist_p(user_name) {
  //   const users = [...this.flat_uniq_users, ...this.watch_users]
  //   return users.some(e => e.user_name === user_name)
  // }

  // 観戦者の追加(対局者は除外する)
  watch_users_set(user_names) {
    const hash = this.name_to_object_hash
    user_names = user_names.filter(user_name => !hash[user_name]) // 対局者を除外する
    this.watch_users = user_names.map(user_name => Item.create(user_name))
  }

  state_toggle() {
    if (this.order_state.constructor.name === "O1State") {
      this.state_change_handle("to_o2_state")
    } else {
      this.state_change_handle("to_o1_state")
    }
  }
}
