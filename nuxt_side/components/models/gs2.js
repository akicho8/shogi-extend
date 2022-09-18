import _ from "lodash"

export const Gs2 = {
  __assert__(value, message = null) {
    if (!value) {
      console.error(value)
      alert(message || "ぶっこわれました")
      debugger
    }
  },

  __assert_equal__(expected, actual, message = null) {
    if (actual !== expected) {
      console.error(`<${expected}> expected but was <${actual}>`)
      alert(message || "ぶっこわれました")
      debugger
    }
  },

  assert_nonzero(v) {
    if (v === 0) {
      throw new Error("divided by 0")
    }
  },

  // 一周してくれる賢い剰余
  // -1 % 3 => 2
  //  4 % 3 => 1
  imodulo(v, n) {
    this.assert_nonzero(n)
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
    this.assert_nonzero(n)
    return Math.floor(v / n)
  },

  // expect(Gs.ary_each_slice_to_a(["a", "b", "c", "d"], 2)).toEqual([["a", "b"], ["c", "d"]])
  // expect(Gs.ary_each_slice_to_a(["a", "b", "c"], 2)).toEqual([["a", "b"], ["c"]])
  // expect(() => Gs.ary_each_slice_to_a(["a", "b"], 0)).toThrow()
  // expect(Gs.ary_each_slice_to_a([], 2)).toEqual([])
  ary_each_slice_to_a(ary, step) {
    if (step <= 0) {
      throw new Error("invalid slice size")
    }
    const new_ary = []
    for (let i = 0; i < ary.length; i += step) {
      new_ary.push(ary.slice(i, i + step))
    }
    return new_ary
  },

  // 元を破壊させない
  ary_reverse(ary) {
    return [...ary].reverse()
  },

  // 元を破壊させない
  ary_shuffle(ary) {
    return _.shuffle([...ary])
  },

  // 文字列をクラス化
  // ただし window に結び付いてないと取得できない
  str_constantize(str) {
    return Function(`return ${str}`)()
  },

  n_times_collect(n, block) {
    const ary = []
    for (let i = 0; i < n; i++) {
      ary.push(block(i))
    }
    return ary
  },

  n_times(n, block) {
    for (let i = 0; i < n; i++) {
      block(i)
    }
  },
}
