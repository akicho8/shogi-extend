import { GX } from "@/components/models/gx.js"
import { Soldier } from "shogi-player/components/models/soldier.js" // FIXME: テストで読み込めない。修正方法不明。
import _ from "lodash"

export class FurigomaPawn {
  constructor(options = {}) {
    this.options = {
      furigoma_random_key: null,
      ...options,
    }
    this.soldier = Soldier.easy_create({piece_key: "P"})
  }

  toss() {
    if (this.__random_call) {
      this.soldier = this.soldier.clone_with({promoted: !this.soldier.promoted})
    }
  }

  get name() {
    return this.soldier.name
  }

  get __random_call() {
    const key = this.options.furigoma_random_key
    if (key === "force_true") {
      return true
    }
    if (key === "force_false") {
      return false
    }
    return _.sample([true, false])
  }
}
