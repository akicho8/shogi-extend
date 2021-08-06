import { mount } from '@vue/test-utils'
import { HandleNameValidator } from '@/components/models/handle_name_validator.js'

describe('HandleNameValidator', () => {
  test('短かくても漢字ならOKにしとく', () => {
    expect(HandleNameValidator.valid("金")).toEqual(true)
  })

  test('文字の連続だけどありがちな名前', () => {
    expect(HandleNameValidator.valid("キキ")).toEqual(true)
    expect(HandleNameValidator.valid("らら")).toEqual(true)
    expect(HandleNameValidator.valid("めめめ")).toEqual(true)
  })

  test('未入力', () => {
    expect(HandleNameValidator.valid("")).toEqual(false)
  })

  test('1文字', () => {
    expect(HandleNameValidator.valid("a")).toEqual(false)
    expect(HandleNameValidator.valid("あ")).toEqual(false)
  })

  test('明かな捨てハンは禁止', () => {
    expect(HandleNameValidator.valid("名無し")).toEqual(false)
    expect(HandleNameValidator.valid("ななし")).toEqual(false)
    expect(HandleNameValidator.valid("nanashi")).toEqual(false)
    expect(HandleNameValidator.valid("nanasi")).toEqual(false)
    expect(HandleNameValidator.valid("通りすがり")).toEqual(false)

    expect(HandleNameValidator.valid("test")).toEqual(false)
    expect(HandleNameValidator.valid("テスト")).toEqual(false)
    expect(HandleNameValidator.valid("てすと")).toEqual(false)
  })

  test('全部数字は禁止', () => {
    expect(HandleNameValidator.valid("123")).toEqual(false)
    expect(HandleNameValidator.valid("７７７")).toEqual(false)
  })

  test('NGワード', () => {
    expect(HandleNameValidator.valid("将棋初心者")).toEqual(false)
    expect(HandleNameValidator.valid("noname")).toEqual(false)
    expect(HandleNameValidator.valid("あああ")).toEqual(false)
    expect(HandleNameValidator.valid("雑　魚")).toEqual(false)
    expect(HandleNameValidator.valid("雑 魚")).toEqual(false)
  })

  test('prefixが含まれる', () => {
    expect(HandleNameValidator.valid("親しみのある")).toEqual(false)
  })

  test('長すぎる', () => {
    expect(HandleNameValidator.valid("12345678901234567")).toEqual(false)
  })

  test('文章を書いている', () => {
    expect(HandleNameValidator.valid("よろしく。")).toEqual(false)
  })

  test('絵文字のみ', () => {
    expect(HandleNameValidator.valid("🥇")).toEqual(false)
    expect(HandleNameValidator.valid("🥇🥇")).toEqual(false)
  })
})
