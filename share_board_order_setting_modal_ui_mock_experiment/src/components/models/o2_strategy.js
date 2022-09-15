import { MyMath } from "./my_math.js"

export class O2Strategy {
  constructor(sizes, turn) {
    this.sizes = sizes
    this.turn = turn
  }

  // チームのインデックスを返す
  get team_index() {
    return MyMath.imodulo(this.turn, this.sizes.length)
  }

  // チーム内のインデックスを返す
  get user_index() {
    const index = Math.floor(this.turn / this.sizes.length)
    const length = this.sizes[this.team_index]
    if (length === 0) {
      return null
    }
    return MyMath.imodulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.sizes, this.turn, this.team_index, this.user_index]
  }
}
