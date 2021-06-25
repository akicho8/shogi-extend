import { mount } from '@vue/test-utils'
import { HandleNameValidator } from '@/components/models/handle_name_validator.js'

describe('HandleNameValidator', () => {
  test('短かくても漢字ならOKにしとく', () => {
    expect(HandleNameValidator.valid("金")).toEqual(true)
  })

  test('未入力', () => {
    expect(HandleNameValidator.valid("")).toEqual(false)
  })

  test('短かすぎるアルファベット', () => {
    expect(HandleNameValidator.valid("a")).toEqual(false)
    expect(HandleNameValidator.valid("aa")).toEqual(false)
    expect(HandleNameValidator.valid("aaa")).toEqual(false)
    expect(HandleNameValidator.valid("aａa")).toEqual(false)
    expect(HandleNameValidator.valid("abbbc")).toEqual(false)
  })

  test('明かな捨てハンは禁止', () => {
    expect(HandleNameValidator.valid("名無し")).toEqual(false)
    expect(HandleNameValidator.valid("ななし")).toEqual(false)
    expect(HandleNameValidator.valid("nanashi")).toEqual(false)
    expect(HandleNameValidator.valid("nanasi")).toEqual(false)
    expect(HandleNameValidator.valid("通りすがり")).toEqual(false)
  })

  test('全部数字は禁止', () => {
    expect(HandleNameValidator.valid("123")).toEqual(false)
    expect(HandleNameValidator.valid("７７７")).toEqual(false)
  })
})
