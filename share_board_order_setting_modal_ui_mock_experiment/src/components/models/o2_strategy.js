import { Gs2 } from "../../../../nuxt_side/components/models/gs2.js"

export class O2Strategy {
  constructor(sizes, turn, tegoto, kaisi) {
    this.sizes = sizes
    this.turn = turn          // N手目
    this.tegoto = tegoto      // N手毎
    this.kaisi = kaisi        // 開始
  }

  // チームのインデックスを返す
  get team_index() {
    return Gs2.imodulo(this.turn + this.kaisi, this.sizes.length)
  }

  // チーム内のインデックスを返す
  get user_index() {
    const index = Gs2.idiv(this.turn, this.sizes.length * this.tegoto)
    const length = this.sizes[this.team_index]
    if (length === 0) {
      return null
    }
    return Gs2.imodulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.sizes, this.turn, this.tegoto, this.kaisi, this.team_index, this.user_index]
  }
}
