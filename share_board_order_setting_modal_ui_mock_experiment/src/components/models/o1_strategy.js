import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"
import { Location } from "../../../../nuxt_side/node_modules/shogi-player/components/models/location.js"

export class O1Strategy {
  constructor(size, turn, tegoto, start) {
    this.size = size          // ユーザーはN人いる
    this.turn = turn          // N手目
    this.tegoto = tegoto      // N手毎
    this.start = start        // 開始
  }

  get team_index() {
    return Gs2.imodulo(this.turn + this.start, Location.count)
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
    return [this.size, this.turn, this.tegoto, this.start, this.team_index, this.user_index]
  }
}
