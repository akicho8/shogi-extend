import { O1Strategy } from "./o1_strategy.js"
import { O2Strategy } from "./o2_strategy.js"
import { OxState } from "./ox_state.js"
import { O1State } from "./o1_state.js"
import { Item } from "./item.js"
import _ from "lodash"
import { GX } from "@/components/models/gs.js"

// TODO: 最後にできれば Immutable にしたい
export class O2State extends OxState {
  constructor(teams = [[], []]) {
    super()
    this.teams = teams
  }

  get state_name() {
    return "O2State"
  }

  // 全体シャッフル
  // users_allocate だけだと3人の場合 2:1 になるため50%の確率で1:2にする
  shuffle_all() {
    this.users_allocate(GX.ary_shuffle(this.teams.flat()))
    if (GX.irand(this.teams.length) === 0) {
      this.swap_run()
    }
  }

  // チーム内シャッフル
  teams_each_shuffle() {
    this.teams = this.teams.map(e => GX.ary_shuffle(e))
    this.cache_clear()
  }

  swap_run() {
    this.teams = GX.ary_rotate(this.teams)
    this.cache_clear()
  }

  // 指定のユーザーを除外する
  user_name_reject(user_name) {
    this.teams = this.teams.map(e => _.reject(e, e => e.user_name === user_name))
    this.cache_clear()
  }

  // demo_set() {
  //   this.users_allocate(["a", "b", "c", "d", "e"])
  // }

  // users を左右に振り分ける
  users_allocate(users) {
    this.teams = [[], []]
    this.cache_clear()
    _.times(users.length, i => {
      const strategy = new O1Strategy(users.length, i, 1, 0) // 0:左右の順で振り分ける
      const user = users[strategy.user_index]
      this.teams[strategy.team_index].push(user)
    })
  }

  // o2ではそのまま振り分けることができる
  users_allocate_from_teams(teams) {
    this.teams = teams
    this.cache_clear()
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
    state.users_allocate(this.black_start_order_uniq_users)
    return state
  }

  get to_o2_state() {
    return this
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 黒から開始して約一周したと仮定したときのユーザーの配列(重複なし, null なし)
  // これは他のにコピーするときに使いやすい
  get black_start_order_uniq_users() {
    const users = GX.n_times_collect(this.round_size, turn => this.turn_to_item(turn, 1, 0))
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
  get swap_enable_p() {
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

  // 黒白の順で分ける
  // a b
  // c
  // で黒から始める場合
  // [
  //   [ "a", "c" ],
  //   [ "b"      ],
  // ]
  // 1:100 人だと無駄が多いことがわかるので、つまり teams だけを参照するのがいい
  get simple_teams() {
    return this.teams.map(users => users.map(e => e.user_name))
  }

  // 指定の色のチームのメンバー数を返す
  team_member_count(location) {
    return this.teams[location.code].length
  }

  ////////////////////////////////////////////////////////////////////////////////

  // {
  //   "watch_users": [],
  //   "order_state": {
  //     "state_name": "O2State",
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
