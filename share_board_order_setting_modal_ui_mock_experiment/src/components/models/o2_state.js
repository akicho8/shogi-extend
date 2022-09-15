import { O1Strategy } from "./o1_strategy.js"
import { O2Strategy } from "./o2_strategy.js"
import { O1State } from "./o1_state.js"
import _ from "lodash"

export class O2State {
  constructor() {
    this.main_teams   = [[], []]
    this.member_other = []
  }

  demo_set() {
    this.main_teams = [["a"], ["b", "c"]]
    this.member_other = []
  }

  reset_by_users(users) {
    this.main_teams = [[], []]
    this.member_other = []

    users.forEach((e, i) => {
      const strategy = new O1Strategy(users.length, i, 1)
      const user = users[strategy.user_index]
      this.main_teams[strategy.team_index].push(user)
    })
  }

  current_user_by_turn(turn) {
    const strategy = new O2Strategy(this.main_teams.map(e => e.length), turn)
    return this.main_teams[strategy.team_index][strategy.user_index]
  }

  get to_o1_state() {
    const state = new O1State()
    this.main_teams.flat().forEach((e, turn) => {
      const strategy = new O2Strategy(this.main_teams.map(e => e.length), turn)
      const name = this.main_teams[strategy.team_index][strategy.user_index]
      state.users.push(name)
    })
    return state
  }

  get to_o2_state() {
    return this
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 一周したと仮定したときの選択されたユーザーの配列
  get round_users() {
    const users = []
    _.times(this.round_size, turn => {
      users.push(this.current_user_by_turn(turn))
    })
    return users
  }

  // すべてのユーザーが選択されるまでの最長ターン数
  // a b であれば "a" と "b c d" だと "b c d" の方が大きく 3 なので 3 * 2 = 6 となる
  //   c
  //   d
  // a d であれば "a b c" と "b" だと "a b c" の方が大きく 3 なので 3 * 2 = 6 となるが、右側を選択しないので 5 になる
  // b
  // c
  get round_size() {
    const a = this.main_teams[0].length
    const b = this.main_teams[1].length
    if (a <= b) {
      return b * 2
    } else {
      return a * 2 - 1
    }
  }

  ////////////////////////////////////////////////////////////////////////////////
}
