import { Gs2 } from "@/components/models/gs2.js"

export class Dice {
  constructor() {
    this.roll()
  }

  roll() {
    return this.value = Gs2.dice_roll()
  }

  get to_icon() {
    return `dice-${this.value}-outline`
  }
}
