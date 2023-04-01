import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

export class O2Strategy {
  constructor(sizes, turn, tegoto, scolor) {
    // このようなチェックを自力で行うのであれば TypeScript にした方がいいのかもしれない
    Gs.assert(sizes != null, "sizes != null")
    Gs.assert(turn != null, "turn != null")
    Gs.assert(tegoto != null, "tegoto != null")
    Gs.assert(scolor != null, "scolor != null")

    Gs.assert(tegoto >= 1, "tegoto >= 1")
    Gs.assert(_.isArray(sizes), "_.isArray(sizes)")
    Gs.assert(sizes.length == 2, "sizes.length == 2")

    this.sizes  = sizes  // [2, 3] のような形式
    this.turn   = turn   // N手目
    this.tegoto = tegoto // N手毎
    this.scolor = scolor // 開始
  }

  // チームのインデックスを返す
  get team_index() {
    Gs.assert(this.sizes.length >= 1, "this.sizes.length >= 1")
    return Gs.imodulo(this.turn + this.scolor, this.sizes.length)
  }

  // チーム内のインデックスを返す
  get user_index() {
    Gs.assert(this.tegoto >= 1, "this.tegoto >= 1")
    const index = Gs.idiv(this.turn, this.sizes.length * this.tegoto)
    const length = this.sizes[this.team_index]
    if (length === 0) {
      return null
    }
    Gs.assert(length >= 1, "length >= 1")
    return Gs.imodulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.sizes, this.turn, this.tegoto, this.scolor, this.team_index, this.user_index]
  }
}
