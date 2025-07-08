import { RoomKeyValidator } from "@/components/ShareBoard/models/room_key_validator.js"

describe("RoomKeyValidator", () => {
  test("空文字", () => {
    expect(RoomKeyValidator.valid_p("")).toEqual(false)
  })

  test("長い", () => {
    expect(RoomKeyValidator.valid_p("12345678901234567890123456789012")).toEqual(true)
    expect(RoomKeyValidator.valid_p("12345678901234567890123456789012_")).toEqual(false)
  })

  test("危険文字", () => {
    expect(RoomKeyValidator.valid_p("foo,bar")).toEqual(false)
  })
})
