import { O1State } from "./o1_state.js"
import { O2State } from "./o2_state.js"
import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"

export class OrderUnit {
  constructor() {
    this.order_state = new O2State()
    this.watch_users = []
  }

  sample_set() {
    this.order_state.reset_by_users(["a", "b", "c", "d", "e"])
  }

  shuffle_all() {
    this.order_state.shuffle_all()
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
    this.watch_users = []
  }

  current_user_by_turn(turn, change_per, scolor) {
    return this.order_state.current_user_by_turn(turn, change_per, scolor)
  }

  state_switch_to(method) {
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

  dump_and_load() {
    this.attributes = this.attributes
  }
}
