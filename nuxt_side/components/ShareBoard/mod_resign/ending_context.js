// Value Object

import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"
import { EndingRouteInfo } from "./ending_route_info.js"

export class EndingContext {
  static create(...args) {
    return new this(...args)
  }

  constructor(params = {}) {
    // 全員で共通
    this.ending_route_key = params.ending_route_key    // 投了にいたった理由
    this.win_location_key = params.win_location_key    // 勝った方
    this.teams_hash       = params.teams_hash ?? {}    // 対局者たち (だが未使用)

    // それぞれ違う
    this.my_location_key  = params.my_location_key      // 自分が所属するチーム

    Object.freeze(this)
    Object.freeze(this.teams_hash)
  }

  // Delegates
  get toast_notify_p() { return this.ending_route_info.toast_notify_p }
  get modal_notify_p() { return this.ending_route_info.modal_notify_p }
  get route_name()     { return this.ending_route_info.name           }

  // get checkmate_p() {
  //   return this.ending_route_info.key === "er_auto_checkmate"
  // }

  // 発言内容
  // 勝者と敗者でメッセージを分けるのではなく SF6 やスプラのように勝者側のメッセージを全員に出す
  get message() {
    if (this.win_location) {
      return `${this.route_name}で${this.win_location.name}の勝ちです`
    } else {
      return this.route_name
    }
  }

  // 一言でいうと

  // (未使用)
  get win_player_names() {
    if (this.win_location) {
      const str = this.teams_hash[this.win_location.key] ?? ""
      return str.split(",") // FIXME: こんなことするなら最初から配列にしておけばよい
    }
  }

  // 自分は勝ったのか？ (未使用)
  get i_am_win_p() {
    if (this.win_location) {
      return this.win_location === this.my_location
    }
  }

  // 勝者側
  get win_location() {
    return Location.fetch_if(this.win_location_key)
  }

  // 自分チーム (未使用)
  get my_location() {
    return Location.fetch_if(this.my_location_key)
  }

  // ルート
  get ending_route_info() {
    return EndingRouteInfo.fetch(this.ending_route_key)
  }
}
