export const MyMath = {
  assert_nonzero(v) {
    if (v === 0) {
      throw new Error("divided by 0")
    }
  },

  // 一周してくれる賢い剰余
  // -1 % 3 => 2
  //  4 % 3 => 1
  ruby_like_modulo(v, n) {
    this.assert_nonzero(n)
    v = v % n
    v = Math.trunc(v)
    if (v < 0) {
      v = n + v
    }
    return v + 0
  }
}
