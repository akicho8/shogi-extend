import { O1Strategy } from "./o1_strategy.js"
import { O2Strategy } from "./o2_strategy.js"
import { OxState } from "./ox_state.js"
import { O1State } from "./o1_state.js"
import _ from "lodash"
import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"

// TODO: 最後にできれば Immutable にしたい
export class O2State extends OxState {
  constructor(teams = [[], []]) {
    super()
    this.teams = teams
  }

  shuffle_core() {
    this.reset_by_users(Gs2.ary_shuffle(this.teams.flat()))
  }

  swap_exec() {
    this.teams = [this.teams[1], this.teams[0]]
  }

  demo_set() {
    this.teams = [["a"], ["b", "c"]]
  }

  reset_by_users(users) {
    this.teams = [[], []]
    _.times(users.length, i => {
      const strategy = new O1Strategy(users.length, i, 1, 0)
      const user = users[strategy.user_index]
      this.teams[strategy.team_index].push(user)
    })
  }

  strategy_create(...args) {
    return new O2Strategy(this.teams.map(e => e.length), ...args)
  }

  current_user_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return this.teams[strategy.team_index][strategy.user_index]
  }

  current_team_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return strategy.team_index
  }

  get to_o1_state() {
    const state = new O1State()

    if (false) {
      _.times(this.round_size, turn => {
        const strategy = new O2Strategy(this.teams.map(e => e.length), turn, 1, 0)
        const name = this.teams[strategy.team_index][strategy.user_index]
        console.log(name)
        if (!state.users.includes(name)) {
          state.users.push(name)
        }
      })
    } else {
      const users = _.compact(_.uniq(this.round_users))
      state.reset_by_users(users)
    }
    return state
  }

  get to_o2_state() {
    return this
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 一周したと仮定したときの選択されたユーザーの配列
  // null を含む
  get round_users() {
    const users = []
    _.times(this.round_size, turn => {
      users.push(this.current_user_by_turn(turn, 1, 0))
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
    const a = this.teams[0].length
    const b = this.teams[1].length
    if (a <= b) {
      return b * 2
    } else {
      return a * 2 - 1
    }
  }

  ////////////////////////////////////////////////////////////////////////////////

  get attributes() {
    return {
      ...super.attributes,
      teams: this.teams,
    }
  }
  set attributes(v) {
    this.teams = v.teams
  }
}

window.O2State = O2State
