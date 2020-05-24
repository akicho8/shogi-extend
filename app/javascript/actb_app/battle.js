import { Question } from "./question.js"

export class Battle {
  constructor(battle) {
    Object.assign(this, battle)
    this.best_questions = this.best_questions.map(e => new Question(e))
  }

  // 問題数
  get questions_count() {
    return this.best_questions.length
  }
}
