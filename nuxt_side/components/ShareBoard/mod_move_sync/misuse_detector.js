import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export class MisuseDetector {
  static create(...args) {
    return new this(...args)
  }

  constructor(options = {}) {
    this.options = {
      count_max: null,
      callback: () => {},
      ...options,
    }

    Object.freeze(this.options)

    this.reset()
  }

  reset() {
    this.count        = null
    this.location_key = null
    this.first_turn   = null
    this.last_turn    = null
  }

  call({location_key, turn}) {
    GX.assert_present(location_key)
    GX.assert_present(turn)

    if (this.location_key !== location_key) {
      this.location_key = location_key
      this.count = 0
      this.first_turn = turn
    }

    this.count += 1
    this.last_turn = turn

    if (this.options.count_max != null) {
      if (this.count >= this.options.count_max) {
        if (this.first_turn === 1 || this.first_turn === 2) { // 先手であれば初手で、後手であれ2手目だから 1 or 2
          this.reset()
          this.options.callback()
        }
      }
    }
  }
}
