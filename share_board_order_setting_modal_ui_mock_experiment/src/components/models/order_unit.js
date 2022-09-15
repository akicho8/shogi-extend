import { O1State } from "./o1_state.js"
import { O2State } from "./o2_state.js"

export class OrderUnit {
  constructor() {
    this.order_state = new O1State()
  }

  sample_set() {
    this.order_state.reset_by_users(["a", "b", "c", "d", "e"])
  }

  clear() {
    this.order_state.reset_by_users([])
  }

  current_user_by_turn(turn, tegoto) {
    return this.order_state.current_user_by_turn(turn, tegoto)
  }

  state_change_handle(method) {
    this.order_state = this.order_state[method]
  }
}
