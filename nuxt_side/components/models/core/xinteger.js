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

  idivmod(v, n) {
    return [this.idiv(v, n), this.imodulo(v, n)]
  },

  even_p(v) {
    return (v % 2) === 0
  },

  odd_p(v) {
    return !this.even_p(v)
  },

  gcd(a, b) {
    if (a === 0) {
      return b
    }
    return this.gcd(b % a, a)
  },

  lcm(a, b) {
    return a * b / this.gcd(a, b)
  },

  iclamp(value, min, max) {
    if (max < max) {
      throw new Error("min argument must be smaller than max argument")
    }
    if (value < min) {
      value = min
    }
    if (max < value) {
      value = max
    }
    return value
  },
}
