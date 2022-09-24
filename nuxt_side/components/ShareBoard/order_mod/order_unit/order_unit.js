// 順番管理
// ・観戦者はこのクラスだけが持つ
// ・O1State, O2State を切り替える
// ・切り替えても観戦者には何も影響がない

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

  // Delegate Methods

  get main_user_count()                 { return this.order_state.main_user_count                       }
  get empty_p()                         { return this.order_state.empty_p                               }
  get self_vs_self_p()                  { return this.order_state.self_vs_self_p                        }
  get one_vs_one_p()                    { return this.order_state.one_vs_one_p                          }
  get many_vs_many_p()                  { return this.order_state.many_vs_many_p                        }

  get black_start_order_uniq_users()    { return this.order_state.black_start_order_uniq_users          }
  first_user(scolor)                    { return this.order_state.first_user(scolor)                    }
  real_order_users(tegoto, scolor)      { return this.order_state.real_order_users(tegoto, scolor)      }
  real_order_users_to_s(tegoto, scolor) { return this.order_state.real_order_users_to_s(tegoto, scolor) }
  get hash()                            { return this.order_state.hash                                  }
  get flat_uniq_users()                 { return this.order_state.flat_uniq_users                       }
  get round_size()                      { return this.order_state.round_size                            }
  get swap_enable_p()                   { return this.order_state.swap_enable_p                         }
  get error_messages()                  { return this.order_state.error_messages                        }
  users_allocate(users)                 { this.order_state.users_allocate(users)                        }
  shuffle_core()                        { this.order_state.shuffle_core()                               }
  swap_run()                            { this.order_state.swap_run()                                   }

  constructor() {
    this.order_state = new O2State()
    this.watch_users = []
  }

  user_names_allocate(user_names) {
    const users = user_names.map(user_name => Item.create(user_name))
    this.order_state.users_allocate(users)
  }

  clear() {
    this.order_state.users_allocate([])
    this.watch_users = []
  }

  sample_set() {
    this.user_names_allocate(["a", "b", "c", "d", "e"])
  }

  furigoma_core(swap_flag) {
    if (swap_flag) {
      this.swap_run()
    }
  }

  turn_to_item(turn, tegoto, scolor) {
    return this.order_state.turn_to_item(turn, tegoto, scolor)
  }

  state_switch_to(method) {
    Gs2.__assert__(this.order_state[method], "this.order_state[method]")
    this.order_state = this.order_state[method]
  }

  get state_name() {
    return this.order_state.constructor.name
  }

  // 観戦者は含まないでよい
  get attributes() {
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

  // 名前から順番を知るためのハッシュ
  // a b
  //   c
  // だった場合 { a: [0, 2], b: [1], c:[3] }
  name_to_turns_hash(scolor) {
    const users = this.real_order_users(1, scolor)
    let index = 0
    return users.reduce((a, e) => {
      if (e) {
        if (a[e.user_name] == null) {
          a[e.user_name] = []
        }
        a[e.user_name].push(index)
      }
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
    return `[黒開始:${list0}] [白開始:${list1}] [観:${wlist}] [整:${this.valid_p}] [替:${this.swap_enable_p ? 'o' : 'x'}] (${this.state_name})`
  }

  // 全員追加
  // 1. 空なら全員対局者にする
  // 2. 空でなければ対局者以外を観戦者にする
  auto_users_set(user_names) {
    if (this.empty_p) {
      this.user_names_allocate(user_names)
    } else {
      const hash = this.name_to_object_hash
      user_names = user_names.filter(user_name => !hash[user_name]) // 対局者を除外する
      this.watch_users = user_names.map(user_name => Item.create(user_name))
    }
  }

  state_toggle() {
    if (this.order_state.constructor.name === "O1State") {
      this.state_switch_to("to_o2_state")
    } else {
      this.state_switch_to("to_o1_state")
    }
  }
}
