import { BattleMembership } from "./battle_membership.js"

export class Battle {
  constructor(battle) {
    Object.assign(this, battle)
    this.memberships = this.memberships.map(e => new BattleMembership(e))
  }
}
