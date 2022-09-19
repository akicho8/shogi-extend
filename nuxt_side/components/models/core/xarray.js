import _ from "lodash"

export const Xarray = {
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

  // 必ず配列にする
  ary_wrap(ary) {
    if (_.isArray(ary)) {
      return ary
    }
    return [ary]
  },
}
