import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"

export class V1Strategy {
  constructor(size, turn, change_per, scolor) {
    GX.assert(size != null, "size != null")
    GX.assert(turn != null, "turn != null")
    GX.assert(change_per != null, "change_per != null")
    GX.assert(scolor != null, "scolor != null")
    GX.assert(change_per >= 1, "change_per >= 1")

    this.size = size          // ユーザーはN人いる
    this.turn = turn          // N手目
    this.change_per = change_per      // N手毎
    this.scolor = scolor      // 開始 0 or 1
  }

  // チームのインデックスを返す
  get team_index() {
    return GX.imodulo(this.turn, Location.count)
  }

  // チーム内のインデックスを返す
  // この位置の奴が現在のプレイヤー
  get user_index() {
    if (this.size === 0) {
      return null
    }
    const step = GX.idiv(this.turn, Location.count * this.change_per) * Location.count
    const index = step + this.team_index
    return GX.imodulo(index, this.size)
  }

  // private

  // 主にデバッグ用
  get to_a() {
    return [this.size, this.turn, this.change_per, this.scolor, this.team_index, this.user_index]
  }
}
