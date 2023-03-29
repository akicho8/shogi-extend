import { Xassertion } from "./xassertion.js"

export const Xrand = {
  // irand(3) で 0..2
  irand(n = null) {
    if (n >= 1.0) {
      return Math.floor(Math.random() * n)
    } else {
      return Math.random()
    }
  },

  // 整数で min..max の間の乱数
  // https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Math/random
  irand_range(min, max) {
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min + 1) + min)
  },

  // さいころを振る
  dice_roll(max = 6) {
    return this.irand_range(1, max)
  },
}
