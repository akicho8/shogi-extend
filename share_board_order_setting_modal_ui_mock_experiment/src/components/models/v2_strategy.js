import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"

export class V2Strategy {
  constructor(sizes, turn, change_per, scolor) {
    this.sizes = sizes
    this.turn = turn          // N手目
    this.change_per = change_per      // N手毎
    this.scolor = scolor        // 開始
  }

  // チームのインデックスを返す
  get team_index() {
    return Gs2.imodulo(this.turn + this.scolor, this.sizes.length)
  }

  // チーム内のインデックスを返す
  get user_index() {
    const index = Gs2.idiv(this.turn, this.sizes.length * this.change_per)
    const length = this.sizes[this.team_index]
    if (length === 0) {
      return null
    }
    return Gs2.imodulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.sizes, this.turn, this.change_per, this.scolor, this.team_index, this.user_index]
  }
}
