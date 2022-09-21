import { O1Strategy } from "./o1_strategy.js"
import { O2Strategy } from "./o2_strategy.js"
import { OxState } from "./ox_state.js"
import { O1State } from "./o1_state.js"
import { Item } from "./item.js"
import _ from "lodash"
import { Gs2 } from "@/components/models/gs2.js"

// TODO: 最後にできれば Immutable にしたい
export class O2State extends OxState {
  constructor(teams = [[], []]) {
    super()
    this.teams = teams
  }

  shuffle_core() {
    this.users_allocate(Gs2.ary_shuffle(this.teams.flat()))
  }

  swap_run() {
    this.teams = [this.teams[1], this.teams[0]]
  }

  // demo_set() {
  //   this.users_allocate(["a", "b", "c", "d", "e"])
  // }

  users_allocate(users) {
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

  turn_to_item(...args) {
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
      state.users_allocate(this.black_start_order_uniq_users)
    }
    return state
  }

  get to_o2_state() {
    return this
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 黒から開始して約一周したと仮定したときのユーザーの配列(重複なし, null なし)
  // これは他のにコピーするときに使いやすい
  get black_start_order_uniq_users() {
    const users = []
    _.times(this.round_size, turn => {
      users.push(this.turn_to_item(turn, 1, 0))
    })
    return _.compact(_.uniq(users))
  }

  // 対局者の数
  get main_user_count() {
    return this.teams.reduce((a, e) => a + e.length, 0)
  }

  // 順不同で含まれているユーザーたちを返す
  get flat_uniq_users() {
    return this.teams.flat()
  }

  // すべてのユーザーが選択されるまでの最長ターン数
  // [[a], [b, c, d]] の場合、黒から始めたとすれば 6 で白からなら 5 になる
  // 厳密でなくていいので単に多い方の2倍で良い
  get round_size() {
    return _.max(this.teams.map(e => e.length)) * this.teams.length
  }

  // 先後入れ替えできるか？
  get irekae_can_p() {
    return true
  }

  // 準備できたか？
  get error_messages() {
    const messages = super.error_messages
    if (!this.empty_p) {
      if (this.teams.some(e => e.length === 0)) {
        messages.push(`各チームに最低1人入れてください`)
      }
    }
    return messages
  }

  ////////////////////////////////////////////////////////////////////////////////

  // {
  //   "watch_users": [],
  //   "order_state": {
  //     "class_name": "O2State",
  //     "teams": [
  //       [
  //         "a",
  //         "c",
  //         "e"
  //       ],
  //       [
  //         "b",
  //         "d"
  //       ]
  //     ]
  //   }
  // }
  get attributes() {
    return {
      ...super.attributes,
      teams: this.teams.map(e => e.map(e => e.as_json))
    }
  }
  set attributes(v) {
    this.teams = v.teams.map(e => e.map(user_name => Item.create(user_name)))
  }
}

if (typeof window !== 'undefined') {
  window.O2State = O2State
}
