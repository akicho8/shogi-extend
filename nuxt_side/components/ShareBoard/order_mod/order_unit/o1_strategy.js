import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"

export class O1Strategy {
  constructor(size, turn, change_per, scolor) {
    Gs.assert(size != null, "size != null")
    Gs.assert(turn != null, "turn != null")
    Gs.assert(change_per != null, "change_per != null")
    Gs.assert(scolor != null, "scolor != null")
    Gs.assert(change_per >= 1, "change_per >= 1")

    this.size = size          // ユーザーはN人いる
    this.turn = turn          // N手目
    this.change_per = change_per      // N手毎
    this.scolor = scolor      // 開始 0 or 1
  }

  // チームのインデックスを返す
  get team_index() {
    return Gs.imodulo(this.turn, Location.count)
  }

  // チーム内のインデックスを返す
  // この位置の奴が現在のプレイヤー
  get user_index() {
    if (this.size === 0) {
      return null
    }
    const step = Gs.idiv(this.turn, Location.count * this.change_per) * Location.count
    const index = step + this.team_index
    return Gs.imodulo(index, this.size)
  }

  // private

  // 主にデバッグ用
  get to_a() {
    return [this.size, this.turn, this.change_per, this.scolor, this.team_index, this.user_index]
  }
}
