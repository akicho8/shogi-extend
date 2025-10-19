import { GX } from "@/components/models/gx.js"
import { FurigomaPawn } from "./furigoma_pawn.js"

export class FurigomaPack {
  static call(...args) {
    const object = new this(...args)
    object.shaka_and_shaka()
    return object
  }

  constructor(options = {}) {
    this.options = {
      size: 5,                     // 「歩」の枚数
      furigoma_random_key: null,   // force_true: 必ず反転, force_false: 必ず反転しない, null: ランダム
      shakashaka_count: null,      // しゃかしゃかする回数 0 なら「歩5枚」
      ...options,
    }
    if (!(this.options.size >= 1 && GX.odd_p(this.options.size))) {
      throw new Error(`歩の枚数は1以上の奇数を指定する: ${this.options.size}`)
    }
    this.values = GX.n_times_collect(this.options.size, () => new FurigomaPawn(this.options))
    this.count = 0
  }

  // 指定回数だけシャッフルする
  shaka_and_shaka() {
    GX.n_times(this.shakashaka_count, () => this.shaka())
  }

  shaka() {
    this.values.forEach(e => e.shaka())
    this.count += 1
  }

  // 逆にする必要があるか？
  get swap_p() {
    return this.tail_count > (this.options.size / 2)
  }

  get message() {
    if (this.swap_p) {
      return `と金が${this.tail_count}枚`
    } else {
      return `歩が${this.head_count}枚`
    }
  }

  get head_count() {
    return this.values.filter(e => e.name === "歩").length
  }

  get tail_count() {
    return this.values.filter(e => e.name === "と").length
  }

  get piece_names() {
    return this.values.map(e => e.name).join("")
  }

  get shakashaka_count() {
    const v = this.options.shakashaka_count
    if (v != null) {
      return parseInt(v)
    }
    return GX.irand_range(10, 20)
  }

  get inspect() {
    return `[${this.count}] ${this.piece_names} ${this.message} ${this.swap_p}`
  }
}
