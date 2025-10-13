import { GX } from "@/components/models/gx.js"
import { Soldier } from "shogi-player/components/models/soldier.js" // FIXME: テストで読み込めない。修正方法不明。
import { Piece } from "shogi-player/components/models/piece.js"
import _ from "lodash"

export class FurigomaPawn {
  constructor(options = {}) {
    this.options = {
      furigoma_random_key: null,
      ...options,
    }
    this.soldier = new Soldier({piece: Piece.fetch("P"), promoted: false})
  }

  shaka() {
    if (this.boolean_random) {
      this.soldier.promoted = !this.soldier.promoted
    }
  }

  get name() {
    return this.soldier.name
  }

  get boolean_random() {
    const key = this.options.furigoma_random_key
    if (key === "is_true") {
      return true
    }
    if (key === "is_false") {
      return false
    }
    return _.sample([true, false])
  }
}
