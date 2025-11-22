// 順番管理
// ・観戦者はこのクラスだけが持つ
// ・V1Operation, V2Operation を切り替える
// ・切り替えても観戦者には何も影響がない

import { V1Operation } from "./v1_operation.js"
import { V2Operation } from "./v2_operation.js"
import { Item } from "./item.js"
import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"
import _ from "lodash"

export class OrderFlow {
  static from_attributes(attributes) {
    const object = new this()
    object.attributes = attributes
    return object
  }

  // 流し込み
  static create(user_names = []) {
    const object = new this()
    object.user_names_allocate(user_names)
    return object
  }

  // Delegate Methods

  get main_user_count()                     { return this.order_operation.main_user_count                           }
  get empty_p()                             { return this.order_operation.empty_p                                   }
  get self_vs_self_p()                      { return this.order_operation.self_vs_self_p                            }
  get one_vs_one_p()                        { return this.order_operation.one_vs_one_p                              }
  get many_vs_many_p()                      { return this.order_operation.many_vs_many_p                            }

  get black_start_order_uniq_users()        { return this.order_operation.black_start_order_uniq_users              }
  first_user(scolor)                        { return this.order_operation.first_user(scolor)                        }
  real_order_users(change_per, scolor)      { return this.order_operation.real_order_users(change_per, scolor)      }
  real_order_users_to_s(change_per, scolor) { return this.order_operation.real_order_users_to_s(change_per, scolor) }
  name_to_turns_hash(scolor)                { return this.order_operation.name_to_turns_hash(scolor)                }
  get name_to_object_hash()                 { return this.order_operation.name_to_object_hash                       }
  get hash()                                { return this.order_operation.hash                                      }
  get flat_uniq_users()                     { return this.order_operation.flat_uniq_users                           }
  get flat_uniq_users_sole()                { return this.order_operation.flat_uniq_users_sole                           }
  get round_size()                          { return this.order_operation.round_size                                }
  get swap_enable_p()                       { return this.order_operation.swap_enable_p                             }
  get member_empty_message()                 { return this.order_operation.member_empty_message                       }
  get team_empty_message()             { return this.order_operation.team_empty_message                           }
  get team_empty_location()                       { return this.order_operation.team_empty_location                           }
  users_allocate(users)                     { this.order_operation.users_allocate(users)                            }
  users_allocate_from_teams(teams)          { this.order_operation.users_allocate_from_teams(teams)                 }
  shuffle_all()                             { this.order_operation.shuffle_all()                                    }
  teams_each_shuffle()                      { this.order_operation.teams_each_shuffle()                             }
  swap_run()                                { this.order_operation.swap_run()                                       }
  user_name_reject(user_name)               { this.order_operation.user_name_reject(user_name)                      } // 順番設定から除外する
  get operation_name()                          { return this.order_operation.operation_name                                }
  cache_clear()                             { this.order_operation.cache_clear()                                    }
  get simple_teams()                        { return this.order_operation.simple_teams                              }
  turn_to_item(turn, change_per, scolor)    { return this.order_operation.turn_to_item(turn, change_per, scolor)    }
  team_member_count(location)           { return this.order_operation.team_member_count(location)           }
  get team_member_counts()                  { return this.order_operation.team_member_counts           }

  constructor() {
    this.order_operation = new V2Operation()
    this.watch_users = []
  }

  user_names_allocate(user_names) {
    const users = user_names.map(user_name => Item.create(user_name))
    this.users_allocate(users)
  }

  user_names_allocate_from_teams(teams) {
    teams = teams.map(e => e.map(user_name => Item.create(user_name)))
    this.users_allocate_from_teams(teams)
  }

  clear() {
    this.users_allocate([])
    this.watch_users = []
  }

  sample_set() {
    this.user_names_allocate(["a", "b", "c", "d", "e"])
  }

  furigoma_core(swap_flag) {
    if (swap_flag) {
      this.swap_run()
    }
  }

  operation_change(method) {
    GX.assert(this.order_operation[method], "this.order_operation[method]")
    this.order_operation = this.order_operation[method]
  }

  // 観戦者は含まないでよい
  get attributes() {
    return this.order_operation.attributes
  }
  set attributes(v) {
    // this.watch_users = v.watch_users
    // const klass = GX.str_constantize(v.operation_name)
    const klass = this.operation_class_hash[v.operation_name]
    const order_operation = new klass()
    order_operation.attributes = v
    this.order_operation = order_operation
  }

  // これを使って new_o.order_flow を作っている
  deep_clone() {
    const object = new this.constructor()
    object.attributes = this.attributes // 内部は同じものを見ているので危険
    return _.cloneDeep(object)          // 別のものにしないと new_o.order_flow が order_flow に即反映されてしまう
  }

  dump_and_load() {
    const json = JSON.parse(JSON.stringify(this.attributes))
    this.clear()
    this.attributes = json
  }

  get valid_p() {
    return GX.blank_p(this.order_operation.member_empty_message)
  }

  get invalid_p() {
    return !this.valid_p
  }

  get inspect() {
    const list0 = this.real_order_users(1, 0).map(e => e ? e.to_s : "?").join("")
    const list1 = this.real_order_users(1, 1).map(e => e ? e.to_s : "?").join("")
    const wlist = this.watch_users.map(e => e.to_s).join(",")
    return `[黒開始:${list0}] [白開始:${list1}] [観:${wlist}] [替:${this.swap_enable_p ? 'o' : 'x'}] (${this.operation_name})`
  }

  // 順番設定モーダル内で使うデータの準備
  // 空のときだけアロケートしてシャッフルを行う
  auto_users_set(user_names, options = {}) {
    options = {
      with_shuffle: true,
      ...options,
    }
    if (this.empty_p) {
      // 空なら全員対局者にする
      this.user_names_allocate(user_names)
      if (options.with_shuffle) {
        this.shuffle_all()       // モーダルを最初に開いたときシャッフル済みにしておく(重要)
      }
    } else {
      // 空でなければ対局者以外を観戦者にする
      this.no_entry_user_only_watch_users_set(user_names)
    }
  }

  // 投票結果を考慮してチーム分けを行う
  // user_names: ["a", "b", "c"]
  // hash: {a: 0, b: 1}
  // となっているとき
  // a → black
  // b → white
  // c → 観戦者とする
  auto_users_set_with_voted_hash(user_names, hash) {
    const vote_only_user_names = user_names.filter(e => hash[e] != null) // 投票者に絞って a b c d になる
    const group = _.groupBy(vote_only_user_names, e => hash[e])          // {0:["a",b"],1:["c","d"]} 0と1のグループに分ける
    const teams = Location.values.map(e => group[e.code] ?? [])          // [["a", "b"], ["c", "d"]]
    this.user_names_allocate_from_teams(teams)                           // 登録
    this.no_entry_user_only_watch_users_set(user_names)                  // 登録してない人は全員観戦者とする
  }

  // user_names のなかでまだ登録されていない人たちをまとめて観戦者とする
  no_entry_user_only_watch_users_set(user_names) {
    const users = user_names.map(e => Item.create(e))
    this.watch_users = users.filter(e => !this.name_to_object_hash[e.user_name])
  }

  operation_toggle() {
    if (this.order_operation.operation_name === "V1Operation") {
      this.operation_change("to_v2_operation")
    } else {
      this.operation_change("to_v1_operation")
    }
  }

  get operation_class_hash() {
    return {
      V1Operation: V1Operation,
      V2Operation: V2Operation,
    }
  }

  get all_user_count() { return this.main_user_count + this.watch_users.length }
}
