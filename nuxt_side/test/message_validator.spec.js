import { MessageValidator } from "@/components/models/arashi_killer/message_validator.js"

describe("MessageValidator", () => {
  test("5文字までの同じ文字列の20連続はダメ", () => {
    expect(MessageValidator.invalid_p("a".repeat(20))).toEqual(true)
    expect(MessageValidator.invalid_p("ab".repeat(20))).toEqual(true)
    expect(MessageValidator.invalid_p("abc".repeat(20))).toEqual(true)
    expect(MessageValidator.invalid_p("abcd".repeat(20))).toEqual(true)
    expect(MessageValidator.invalid_p("abcde".repeat(20))).toEqual(true)
  })

  test("6文字の繰り返しなので通る", () => {
    expect(MessageValidator.invalid_p("abcdef".repeat(20))).toEqual(false)
  })

  test("19文字連続なので通る", () => {
    expect(MessageValidator.invalid_p("a".repeat(19))).toEqual(false)
  })
})
