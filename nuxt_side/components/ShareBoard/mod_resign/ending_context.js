// Value Object

import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"
import { EndingRouteInfo } from "./ending_route_info.js"
import { HandleNameParser } from "@/components/models/handle_name/handle_name_parser.js"

export class EndingContext {
  static create(...args) {
    return new this(...args)
  }

  constructor(params = {}) {
    GX.assert(params.role_group)
    GX.assert_kind_of_string(params.ending_route_key)
    GX.assert_null(params.win_location)
    GX.assert_null(params.my_location)

    // 全員で共通
    this.ending_route_key = params.ending_route_key    // 投了にいたった理由
    this.win_location_key = params.win_location_key    // 勝った方
    this.role_group       = params.role_group          // 対局者たち
    this.illegal_hv_list  = params.illegal_hv_list     // 反則たち
    this.finished_user_name     = params.finished_user_name       // 詰ました人
    this.resigned_user_name         = params.resigned_user_name           // 投了した人
    this.choker_user_name         = params.choker_user_name           // 反則した人

    // それぞれ違う
    this.my_location_key  = params.my_location_key      // 自分が所属するチーム

    Object.freeze(this)
  }

  // // Delegates
  // get toast_notify_p() { return this.ending_route_info.toast_notify_p }
  // get modal_notify_p() { return this.ending_route_info.modal_notify_p }
  // get route_name()     { return this.ending_route_info.name           }

  // get checkmate_p() {
  //   return this.ending_route_info.key === "er_auto_checkmate"
  // }

  //////////////////////////////////////////////////////////////////////////////// それぞれのルートに対応する文言を返す

  get toast_content() { return this.ending_route_info.toast_content?.(this) }
  get talk_content()  { return this.ending_route_info.talk_content?.(this)  }
  get modal_subject() { return this.ending_route_info.modal_subject?.(this) }
  get modal_body()    { return this.ending_route_info.modal_body?.(this)    }

  //////////////////////////////////////////////////////////////////////////////// 反則

  get illegal_names_str() {
    if (this.illegal_p) {
      return this.illegal_hv_list.map(e => e.illegal_info.name).join("と")
    }
  }
  get illegal_p()   { return GX.present_p(this.illegal_hv_list) }
  get illegal_str() { return this.illegal_p ? "反則" : "" }

  //////////////////////////////////////////////////////////////////////////////// 勝敗

  // 勝ったチームの最初にいる人を返す
  get win_team_leader_name() {
    if (this.win_location) {
      return this.role_group[this.win_location.key][0]
    }
  }

  // 勝ち？
  get i_am_win_p() {
    if (this.win_location && this.my_location) {
      return this.win_location === this.my_location
    }
  }

  // 負け？
  get i_am_lose_p() {
    if (this.win_location && this.my_location) {
      return this.win_location !== this.my_location
    }
  }

  get subject_default() {
    // 当事者
    if (this.i_am_win_p) {
      return `勝ち`
    }
    if (this.i_am_lose_p) {
      return `負け`
    }
    // 観戦者
    return "終局"
  }

  get win_location()  { return Location.fetch_if(this.win_location_key) } // 勝者側 (nullの場合あり)
  get lose_location() { return this.win_location?.flip                  } // 敗者側 (nullの場合あり)
  get my_location()   { return Location.fetch_if(this.my_location_key)  } // 自分側 (未使用)

  // ルート
  get ending_route_info() {
    return EndingRouteInfo.fetch(this.ending_route_key)
  }

  get finishing_call_name() { return this.call_name(this.finished_user_name) } // 詰ました人
  get resigner_call_name()  { return this.call_name(this.resigned_user_name) } // 投了した人
  get choker_call_name()    { return this.call_name(this.choker_user_name)   } // 反則した人

  // 勝った側の呼名
  get win_side_call_name() {
    if (this.win_location) {
      let name = null
      if (false) {
        name ??= this.finished_user_name   // 最後に詰ました人をMVPとして優先的に「○○」さんチームとする (詰ましていないときはいない)
      }
      name ??= this.win_team_leader_name // チームの最初にいる人をリーダーとみなして「○○」さんチームとする (必ずいるはず)
      if (name) {
        return [HandleNameParser.call_name(name), this.win_side_team_name].join("")
      }
      return this.win_location.name // ここにくることはない
    }
  }

  get team_name()           { return "チーム" }
  get win_member_many_p()   { return this.member_many_p(this.win_location) }
  get lose_member_many_p()  { return this.member_many_p(this.lose_location) }
  get win_side_team_name()  { return this.win_member_many_p ? this.team_name : "" }
  get lose_side_team_name() { return this.lose_member_many_p ? this.team_name : "" }

  // private

  member_many_p(location) {
    if (location) {
      return this.role_group[location.key].length > 1
    }
  }

  call_name(name) {
    if (name != null) {
      return HandleNameParser.call_name(name)
    }
  }
}
