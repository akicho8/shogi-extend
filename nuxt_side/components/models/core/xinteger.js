import { Xassertion } from "./xassertion.js"

export const Xinteger = {
  // 小数にしない一周してくれる賢い剰余
  // -1 % 3 => 2
  //  4 % 3 => 1
  imodulo(v, n) {
    Xassertion.__assert_nonzero__(n)
    v = v % n
    v = Math.trunc(v)
    if (v < 0) {
      v = n + v
    }
    return v + 0
  },

  // 整数を割ったとき小数にしない
  // -10 % 3 => -4
  idiv(v, n) {
    Xassertion.__assert_nonzero__(n)
    return Math.floor(v / n)
  },

  even_p(v) {
    return (v % 2) === 0
  },

  odd_p(v) {
    return !this.even_p(v)
  },
}
