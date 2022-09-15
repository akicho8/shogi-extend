import { MyMath } from "./my_math.js"

export class O1Strategy {
  constructor(size, turn, tegoto) {
    this.size = size            // ユーザーはN人いる
    this.turn = turn            // N手目
    this.tegoto = tegoto        // N手毎
  }

  get team_index() {
    return MyMath.imodulo(this.turn, this.PAIR)
  }

  get user_index() {
    if (this.size === 0) {
      return null
    }
    const step = MyMath.idiv(this.turn, this.PAIR * this.tegoto) * this.PAIR
    const offset = MyMath.imodulo(this.turn, this.PAIR)
    return MyMath.imodulo(step + offset, this.size)
  }

  get PAIR() {
    return 2 // 交互なので2。1なら一人で連続で何回も指すことになる
  }

  // デバッグ用
  get to_a() {
    return [this.size, this.turn, this.tegoto, this.user_index]
  }
}
