import { V1Strategy } from "./v1_strategy.js"
import { V2Strategy } from "./v2_strategy.js"
import { AbstractOperation } from "./abstract_operation.js"
import { V1Operation } from "./v1_operation.js"
import _ from "lodash"
import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"

// TODO: 最後にできれば Immutable にしたい
export class V2Operation extends AbstractOperation {
  constructor(teams = [[], []]) {
    super()
    this.teams = teams
  }

  shuffle_all() {
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
      const strategy = new V1Strategy(users.length, i, 1, 0)
      const user = users[strategy.user_index]
      this.teams[strategy.team_index].push(user)
    })
  }

  strategy_create(...args) {
    return new V2Strategy(this.teams.map(e => e.length), ...args)
  }

  current_user_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return this.teams[strategy.team_index][strategy.user_index]
  }

  current_team_by_turn(...args) {
    const strategy = this.strategy_create(...args)
    return strategy.team_index
  }

  get to_v1_operation() {
    const operation_object = new V1Operation()

    if (false) {
      _.times(this.round_size, turn => {
        const strategy = new V2Strategy(this.teams.map(e => e.length), turn, 1, 0)
        const name = this.teams[strategy.team_index][strategy.user_index]
        console.log(name)
        if (!operation_object.users.includes(name)) {
          operation_object.users.push(name)
        }
      })
    } else {
      const users = _.compact(_.uniq(this.round_users))
      operation_object.reset_by_users(users)
    }
    return operation_object
  }

  get to_v2_operation() {
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

window.V2Operation = V2Operation
