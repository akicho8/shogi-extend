import { GX } from "@/components/models/gs.js"

export class Dice {
  constructor() {
    this.roll()
  }

  roll() {
    return this.value = GX.dice_roll()
  }

  get to_icon() {
    return `dice-${this.value}-outline`
  }
}
