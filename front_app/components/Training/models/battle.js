import { Question } from "./question.js"
import { BattleMembership } from "./battle_membership.js"

export class Battle {
  constructor(battle) {
    Object.assign(this, battle)

    if (this.best_questions == null) {
      this.best_questions = []
    }
    this.best_questions = this.best_questions.map(e => new Question(e))
    this.memberships = this.memberships.map(e => new BattleMembership(e))
  }

  get questions_count() {
    return this.best_questions.length
  }
}
