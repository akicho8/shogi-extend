import { Gs } from '@/components/models/gs.js'

describe('Gs', () => {
  test('ruby_like_each_slice_to_a', () => {
    expect(Gs.ruby_like_each_slice_to_a(["a", "b", "c", "d"], 2)).toEqual([["a", "b"], ["c", "d"]])
    expect(Gs.ruby_like_each_slice_to_a(["a", "b", "c"], 2)).toEqual([["a", "b"], ["c"]])
    expect(() => Gs.ruby_like_each_slice_to_a(["a", "b"], 0)).toThrow()
    expect(Gs.ruby_like_each_slice_to_a([], 2)).toEqual([])
  })

  test('rand_int_range', () => {
    expect(Gs.rand_int_range(5, 5)).toEqual(5)
  })
})
