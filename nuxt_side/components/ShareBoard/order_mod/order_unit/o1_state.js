import { O1Strategy } from "./o1_strategy.js"
import { OxState } from "./ox_state.js"
import { O2State } from "./o2_state.js"
import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"
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

  swap_run() {
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

  // 一周したと仮定したときの選択されたユーザーの配列(黒から始まる)
  get black_start_order_uniq_users() {
    return this.users
  }

  get user_total_count() {
    return this.users.length
  }

  get flat_uniq_users() {
    return this.users
  }

  // すべてのユーザーが選択されるまでの最長ターン数
  get round_size() {
    return this.users.length
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 先後入れ替えできるか？
  get irekae_can_p() {
    return Gs2.even_p(this.user_total_count)
  }

  // 準備できたか？
  get error_messages() {
    const messages = this.super.error_messages
    return messages
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

if (typeof window !== 'undefined') {
  window.O1State = O1State
}
