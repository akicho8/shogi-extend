import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"

export class O1Strategy {
  constructor(size, turn, tegoto, kaisi) {
    Gs2.__assert__(size != null, "size != null")
    Gs2.__assert__(turn != null, "turn != null")
    Gs2.__assert__(tegoto != null, "tegoto != null")
    Gs2.__assert__(kaisi != null, "kaisi != null")
    Gs2.__assert__(tegoto >= 1, "tegoto >= 1")

    this.size = size          // ユーザーはN人いる
    this.turn = turn          // N手目
    this.tegoto = tegoto      // N手毎
    this.kaisi = kaisi        // 開始
  }

  get team_index() {
    return Gs2.imodulo(this.turn + this.kaisi, Location.count)
  }

  get user_index() {
    if (this.size === 0) {
      return null
    }
    const step = Gs2.idiv(this.turn, Location.count * this.tegoto) * Location.count
    const index = step + this.team_index
    return Gs2.imodulo(index, this.size)
  }

  // デバッグ用
  get to_a() {
    return [this.size, this.turn, this.tegoto, this.kaisi, this.team_index, this.user_index]
  }
}
