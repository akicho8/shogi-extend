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

  test('str_squish', () => {
    expect(Gs.str_squish("")).toEqual("")
    expect(Gs.str_squish(null)).toEqual("")
    expect(Gs.str_squish(" 　 a 　 a,b 　 c 　 ")).toEqual("a a,b c")
  })

  test('str_to_tags', () => {
    expect(Gs.str_to_tags("")).toEqual([])
    expect(Gs.str_to_tags(null)).toEqual([])
    expect(Gs.str_to_tags(" 　 a 　 a,b 　 c 　 ")).toEqual(["a", "b", "c"])
  })

  test('str_to_words', () => {
    expect(Gs.str_to_words("")).toEqual([])
    expect(Gs.str_to_words(null)).toEqual([])
    expect(Gs.str_to_words(" 　 a 　 a,b 　 c 　 ")).toEqual(["a", "a", "b", "c"])
  })

  test('keywords_str_toggle', () => {
    expect(Gs.keywords_str_toggle("")).toEqual("")
    expect(Gs.keywords_str_toggle(null)).toEqual("")
    expect(Gs.keywords_str_toggle("a b", "c")).toEqual("a b c")
    expect(Gs.keywords_str_toggle("a b c", "c")).toEqual("a b")
  })
})
