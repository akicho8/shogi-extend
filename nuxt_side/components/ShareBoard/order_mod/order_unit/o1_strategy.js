import { Gs } from "@/components/models/gs.js"
import { Location } from "shogi-player/components/models/location.js"

export class O1Strategy {
  constructor(size, turn, tegoto, scolor) {
    Gs.__assert__(size != null, "size != null")
    Gs.__assert__(turn != null, "turn != null")
    Gs.__assert__(tegoto != null, "tegoto != null")
    Gs.__assert__(scolor != null, "scolor != null")
    Gs.__assert__(tegoto >= 1, "tegoto >= 1")

    this.size = size          // ユーザーはN人いる
    this.turn = turn          // N手目
    this.tegoto = tegoto      // N手毎
    this.scolor = scolor      // 開始 0 or 1
  }

  // 色番号
  get team_index() {
    return Gs.imodulo(this.turn, Location.count)
  }

  // この位置の奴が現在のプレイヤー
  get user_index() {
    if (this.size === 0) {
      return null
    }
    const step = Gs.idiv(this.turn, Location.count * this.tegoto) * Location.count
    const index = step + this.team_index
    return Gs.imodulo(index, this.size)
  }

  // private

  // 主にデバッグ用
  get to_a() {
    return [this.size, this.turn, this.tegoto, this.scolor, this.team_index, this.user_index]
  }
}
