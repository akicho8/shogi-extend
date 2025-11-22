import { V1Operation } from "./v1_operation.js"
import { V2Operation } from "./v2_operation.js"
import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"

export class OrderFlow {
  constructor() {
    this.order_operation = new V2Operation()
    this.watch_users = []
  }

  sample_set() {
    this.order_operation.reset_by_users(["a", "b", "c", "d", "e"])
  }

  shuffle_all() {
    this.order_operation.shuffle_all()
  }

  furigoma_core(swap_flag) {
    if (swap_flag) {
      this.swap_exec()
    }
  }

  swap_exec() {
    this.order_operation.swap_exec()
  }

  clear() {
    this.order_operation.reset_by_users([])
    this.watch_users = []
  }

  current_user_by_turn(turn, change_per, scolor) {
    return this.order_operation.current_user_by_turn(turn, change_per, scolor)
  }

  operation_change(method) {
    this.order_operation = this.order_operation[method]
  }

  get operation_name() {
    return this.order_operation.constructor.name
  }

  get attributes() {
    return {
      watch_users: this.watch_users,
      order_operation: this.order_operation.attributes,
    }
  }
  set attributes(v) {
    this.watch_users = v.watch_users
    const klass = Gs2.str_constantize(v.order_operation.class_name)
    const order_operation = new klass()
    order_operation.attributes = v.order_operation
    this.order_operation = order_operation
  }

  dump_and_load() {
    this.attributes = this.attributes
  }
}
