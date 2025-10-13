import { O1Strategy } from "./o1_strategy.js"
import { OxState } from "./ox_state.js"
import { O2State } from "./o2_state.js"
import { Item } from "./item.js"

import { GX } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export class O1State extends OxState {
  constructor(users = []) {
    super()
    this.users = users
  }

  get state_name() {
    return "O1State"
  }

  shuffle_all() {
    this.users_allocate(GX.ary_shuffle(this.users))
  }

  teams_each_shuffle() {
    // チームの概念があやふやなためやらない
  }

  swap_run() {
    this.users = GX.ary_each_slice_to_a(this.users, Location.count).flatMap(e => GX.ary_reverse(e))
    this.cache_clear()
  }

  // 指定のユーザーを除外する
  user_name_reject(user_name) {
    this.users = _.reject(this.users, e => e.user_name === user_name)
    this.cache_clear()
  }

  users_allocate(users) {
    this.users = users
    this.cache_clear()
  }

  // o1では振り分けることができないためフラットにする
  // users_allocate_from_teams([["a", "b"], ["c", "d"]]) とされても ["a", "b", "c", "d"] 順にする
  // 2vs2だったら [["a","b"]["c","d"]].transpose が効くが 2vs2 とは限らない
  users_allocate_from_teams(teams) {
    this.users_allocate(teams.flat())
  }

  strategy_create(...args) {
    return new O1Strategy(this.users.length, ...args)
  }

  turn_to_item(...args) {
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
    state.users_allocate(this.users)
    return state
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 一周したと仮定したときの選択されたユーザーの配列(黒から始まる)
  get black_start_order_uniq_users() {
    return this.users
  }

  // 対局者の数
  get main_user_count() {
    return this.users.length
  }

  get flat_uniq_users() {
    return this.users
  }

  // すべてのユーザーが選択されるまでの最長ターン数
  // abc で白からになると baac になる
  get round_size() {
    // return this.users.length + Location.count
    return this.users.length
  }

  ////////////////////////////////////////////////////////////////////////////////

  // 先後入れ替えできるか？
  get swap_enable_p() {
    return GX.even_p(this.main_user_count)
  }

  // 準備できたか？
  get error_messages() {
    const messages = super.error_messages
    return messages
  }

  // 黒白の順で分ける
  // a b
  // c
  // で黒から始める場合
  // [
  //   [ "a" "c" ],
  //   [ "b"     ],
  // ]
  // 1:100 人だと無駄が多いことがわかるので、つまり teams だけを参照するのがいい
  get simple_teams() {
    alert("must not happen")
  }

  // 指定の色のチームのメンバー数を返す
  team_member_count(location) {
  }

  ////////////////////////////////////////////////////////////////////////////////

  // {
  //  "state_name": "O1State",
  //  "users": [
  //    "a",
  //    "b",
  //    "c",
  //    "d",
  //    "e"
  //   }
  // }
  get attributes() {
    return {
      ...super.attributes,
      users: this.users.map(e => e.as_json),
    }
  }

  set attributes(v) {
    this.users = v.users.map(user_name => Item.create(user_name))
  }
}

if (typeof window !== 'undefined') {
  window.O1State = O1State
}
