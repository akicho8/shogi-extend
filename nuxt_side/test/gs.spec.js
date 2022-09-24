import { Gs } from '@/components/models/gs.js'

describe('Gs', () => {
  test('kanji_hankaku_format', () => {
    expect(Gs.kanji_hankaku_format("変換〇一二三四五六七八九")).toEqual("変換0123456789")
  })

  test('normalize_for_autocomplete', () => {
    expect(Gs.normalize_for_autocomplete("Ａ四")).toEqual("a4")
  })
})
