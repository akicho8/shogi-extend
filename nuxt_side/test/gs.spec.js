import { Gs } from '@/components/models/gs.js'

describe('Gs', () => {
  test('ary_each_slice_to_a', () => {
    expect(Gs.ary_each_slice_to_a(["a", "b", "c", "d"], 2)).toEqual([["a", "b"], ["c", "d"]])
    expect(Gs.ary_each_slice_to_a(["a", "b", "c"], 2)).toEqual([["a", "b"], ["c"]])
    expect(() => Gs.ary_each_slice_to_a(["a", "b"], 0)).toThrow()
    expect(Gs.ary_each_slice_to_a([], 2)).toEqual([])
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

  test('hankaku_format', () => {
    expect(Gs.hankaku_format("変換Ａａ０")).toEqual("変換Aa0")
  })

  test('kanji_hankaku_format', () => {
    expect(Gs.kanji_hankaku_format("変換〇一二三四五六七八九")).toEqual("変換0123456789")
  })

  test('normalize_for_autocomplete', () => {
    expect(Gs.normalize_for_autocomplete("Ａ四")).toEqual("a4")
  })
})
