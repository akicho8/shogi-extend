import { RoomKeyValidator } from "@/components/ShareBoard/models/room_key_validator.js"

describe("RoomKeyValidator", () => {
  test("空文字はダメ", () => {
    expect(RoomKeyValidator.valid_p("")).toEqual(false)
  })

  test("32文字を越えるとダメ", () => {
    expect(RoomKeyValidator.valid_p("12345678123456781234567812345678")).toEqual(true)
    expect(RoomKeyValidator.valid_p("12345678123456781234567812345678_")).toEqual(false)
  })

  test("危険文字はダメ", () => {
    expect(RoomKeyValidator.valid_p("foo,bar")).toEqual(false)
  })

  test("全角を含めてホワイトスペースはダメ", () => {
    expect(RoomKeyValidator.valid_p("foo bar")).toEqual(false)
    expect(RoomKeyValidator.valid_p("foo　bar")).toEqual(false)
    expect(RoomKeyValidator.valid_p("foo\tbar")).toEqual(false)
  })

  test("ダンダーバーとハイフンは良い", () => {
    expect(RoomKeyValidator.valid_p("foo-bar")).toEqual(true)
    expect(RoomKeyValidator.valid_p("foo_bar")).toEqual(true)
  })

  test("全角ハイフン", () => {
    expect(RoomKeyValidator.valid_p("ホーム")).toEqual(true)
  })
})
