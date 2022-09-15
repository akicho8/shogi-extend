import { O1Strategy } from "./o1_strategy.js"
import { O2State } from "./o2_state.js"

export class O1State {
  constructor(users = []) {
    this.users = users
  }

  demo_set() {
    this.reset_by_users(["a", "b", "c", "d", "e"])
  }

  reset_by_users(users) {
    this.users = users
  }

  current_user_by_turn(turn, tegoto) {
    const strategy = new O1Strategy(this.users.length, turn, tegoto)
    return this.users[strategy.user_index]
  }

  get to_o1_state() {
    return this
  }

  get to_o2_state() {
    const state = new O2State()
    this.users.forEach((e, i) => {
      const strategy = new O1Strategy(this.users.length, i, 1)
      const user = this.users[strategy.user_index]
      state.main_teams[strategy.team_index].push(user)
    })
    return state
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 一周したと仮定したときの選択されたユーザーの配列
  get round_users() {
    return this.users
  }

  ////////////////////////////////////////////////////////////////////////////////
}
