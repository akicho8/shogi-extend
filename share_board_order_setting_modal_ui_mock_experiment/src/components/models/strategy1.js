import { MyMath } from "./my_math.js"

export class Strategy1 {
  constructor(team, turn) {
    this.team = team
    this.turn = turn
  }

  get team_index() {
    return MyMath.ruby_like_modulo(this.turn, 2)
  }

  get player_index() {
    if (this.team === 0) {
      return null
    }
    return MyMath.ruby_like_modulo(this.turn, this.team)
  }

  // デバッグ用
  get to_a() {
    return [this.team, this.turn, this.player_index]
  }
}
