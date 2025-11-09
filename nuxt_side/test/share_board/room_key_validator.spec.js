import { RoomKeyValidator } from "@/components/ShareBoard/models/room_key_validator.js"

describe("RoomKeyValidator", () => {
  test("空文字はダメ", () => {
    expect(RoomKeyValidator.valid_p("")).toEqual(false)
  })

  test("12文字を越えるとダメ", () => {
    expect(RoomKeyValidator.valid_p("123456789012")).toEqual(true)
    expect(RoomKeyValidator.valid_p("123456789012_")).toEqual(false)
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
})
