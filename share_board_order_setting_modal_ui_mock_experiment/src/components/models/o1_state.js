import { O1Strategy } from "./o1_strategy.js"
import { OxState } from "./ox_state.js"
import { O2State } from "./o2_state.js"
import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"
import { Location } from "../../../../nuxt_side/node_modules/shogi-player/components/models/location.js"
import _ from "lodash"

// value object 化する
export class O1State extends OxState {
  constructor(users = []) {
    super()
    this.users = users
  }

  shuffle_core() {
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
    return new O1Strategy(this.users.length, ...args)
  }

  current_user_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return this.users[strategy.user_index]
  }

  current_team_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return strategy.team_index
  }

  get to_o1_state() {
    return this
  }

  get to_o2_state() {
    const state = new O2State()
    if (false) {
      this.users.forEach((e, i) => {
        const strategy = new O1Strategy(this.users.length, i, 1, 0)
        const user = this.users[strategy.user_index]
        state.teams[strategy.team_index].push(user)
      })
    } else {
      state.reset_by_users(this.users)
    }
    return state
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

window.O1State = O1State
