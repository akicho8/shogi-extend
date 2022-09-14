import { MyMath } from "./my_math.js"

export class Strategy2 {
  constructor(teams, turn) {
    this.teams = teams
    this.turn = turn
  }

  // チームのインデックスを返す
  get team_index() {
    return MyMath.ruby_like_modulo(this.turn, this.teams.length)
  }

  // チーム内のインデックスを返す
  get player_index() {
    const index = Math.floor(this.turn / this.teams.length)
    const length = this.teams[this.team_index]
    if (length === 0) {
      return null
    }
    return MyMath.ruby_like_modulo(index, length)
  }

  // デバッグ用
  get to_a() {
    return [this.teams, this.turn, this.team_index, this.player_index]
  }
}
