import { Gs } from "@/components/models/gs.js"

export class Dice {
  constructor() {
    this.roll()
  }

  roll() {
    return this.value = Gs.dice_roll()
  }

  get to_icon() {
    return `dice-${this.value}-outline`
  }
}
