import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"
import { Location } from "../../../../nuxt_side/node_modules/shogi-player/components/models/location.js"

export class V1Strategy {
  constructor(size, turn, change_per, scolor) {
    this.size = size          // ユーザーはN人いる
    this.turn = turn          // N手目
    this.change_per = change_per      // N手毎
    this.scolor = scolor        // 開始
  }

  get team_index() {
    return Gs2.imodulo(this.turn + this.scolor, Location.count)
  }

  get user_index() {
    if (this.size === 0) {
      return null
    }
    const step = Gs2.idiv(this.turn, Location.count * this.change_per) * Location.count
    const index = step + this.team_index
    return Gs2.imodulo(index, this.size)
  }

  // デバッグ用
  get to_a() {
    return [this.size, this.turn, this.change_per, this.scolor, this.team_index, this.user_index]
  }
}
