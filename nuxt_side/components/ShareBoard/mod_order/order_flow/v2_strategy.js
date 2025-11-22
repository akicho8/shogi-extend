import { GX } from "@/components/models/gx.js"
import _ from "lodash"

export class V2Strategy {
  constructor(sizes, turn, change_per, scolor) {
    // このようなチェックを自力で行うのであれば TypeScript にした方がいいのかもしれない
    GX.assert(sizes != null, "sizes != null")
    GX.assert(turn != null, "turn != null")
    GX.assert(change_per != null, "change_per != null")
    GX.assert(scolor != null, "scolor != null")

    GX.assert(change_per >= 1, "change_per >= 1")
    GX.assert(_.isArray(sizes), "_.isArray(sizes)")
    GX.assert(sizes.length === 2, "sizes.length === 2")

    this.sizes  = sizes  // [2, 3] のような形式
    this.turn   = turn   // N手目
    this.change_per = change_per // N手毎
    this.scolor = scolor // 開始
  }

  // チームのインデックスを返す
  get team_index() {
    GX.assert(this.sizes.length >= 1, "this.sizes.length >= 1")
    return GX.imodulo(this.turn + this.scolor, this.sizes.length)
  }

  // チーム内のインデックスを返す
  // この位置の奴が現在のプレイヤー
  get user_index() {
    GX.assert(this.change_per >= 1, "this.change_per >= 1")
    const index = GX.idiv(this.turn, this.sizes.length * this.change_per)
    const length = this.sizes[this.team_index]
    if (length === 0) {
      return null
    }
    GX.assert(length >= 1, "length >= 1")
    return GX.imodulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.sizes, this.turn, this.change_per, this.scolor, this.team_index, this.user_index]
  }
}
