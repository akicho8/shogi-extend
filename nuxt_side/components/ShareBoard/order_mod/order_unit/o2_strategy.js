import { Gs } from "@/components/models/gs.js"
import _ from "lodash"

export class O2Strategy {
  constructor(sizes, turn, tegoto, scolor) {
    // このようなチェックを自力で行うのであれば TypeScript にした方がいいのかもしれない
    Gs.__assert__(sizes != null, "sizes != null")
    Gs.__assert__(turn != null, "turn != null")
    Gs.__assert__(tegoto != null, "tegoto != null")
    Gs.__assert__(scolor != null, "scolor != null")

    Gs.__assert__(tegoto >= 1, "tegoto >= 1")
    Gs.__assert__(_.isArray(sizes), "_.isArray(sizes)")
    Gs.__assert__(sizes.length == 2, "sizes.length == 2")

    this.sizes  = sizes  // [2, 3] のような形式
    this.turn   = turn   // N手目
    this.tegoto = tegoto // N手毎
    this.scolor = scolor // 開始
  }

  // チームのインデックスを返す
  get team_index() {
    Gs.__assert__(this.sizes.length >= 1, "this.sizes.length >= 1")
    return Gs.imodulo(this.turn + this.scolor, this.sizes.length)
  }

  // チーム内のインデックスを返す
  get user_index() {
    Gs.__assert__(this.tegoto >= 1, "this.tegoto >= 1")
    const index = Gs.idiv(this.turn, this.sizes.length * this.tegoto)
    const length = this.sizes[this.team_index]
    if (length === 0) {
      return null
    }
    Gs.__assert__(length >= 1, "length >= 1")
    return Gs.imodulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.sizes, this.turn, this.tegoto, this.scolor, this.team_index, this.user_index]
  }
}
