import { V1Strategy } from "./v1_strategy.js"
import { AbstractOperation } from "./abstract_operation.js"
import { V2Operation } from "./v2_operation.js"
import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"
import { Location } from "../../../../nuxt_side/node_modules/shogi-player/components/models/location.js"
import _ from "lodash"

// value object 化する
export class V1Operation extends AbstractOperation {
  constructor(users = []) {
    super()
    this.users = users
  }

  shuffle_all() {
    this.reset_by_users(Gs2.ary_shuffle(this.users))
  }

  swap_exec() {
    this.users = Gs2.ary_each_slice_to_a(this.users, Location.count).flatMap(e => Gs2.ary_reverse(e))
  }

  demo_set() {
    this.reset_by_users(["a", "b", "c", "d", "e"])
  }

  reset_by_users(users) {
    this.users = users
  }

  strategy_create(...args) {
    return new V1Strategy(this.users.length, ...args)
  }

  current_user_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return this.users[strategy.user_index]
  }

  current_team_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return strategy.team_index
  }

  get to_v1_operation() {
    return this
  }

  get to_v2_operation() {
    const operation_object = new V2Operation()
    if (false) {
      this.users.forEach((e, i) => {
        const strategy = new V1Strategy(this.users.length, i, 1, 0)
        const user = this.users[strategy.user_index]
        operation_object.teams[strategy.team_index].push(user)
      })
    } else {
      operation_object.reset_by_users(this.users)
    }
    return operation_object
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 一周したと仮定したときの選択されたユーザーの配列
  get round_users() {
    return this.users
  }

  ////////////////////////////////////////////////////////////////////////////////

  get attributes() {
    return {
      ...super.attributes,
      users: this.users,
    }
  }

  set attributes(v) {
    this.users = v.users
  }
}

window.V1Operation = V1Operation
