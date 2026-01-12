import { DotSfen } from "@/components/models/dot_sfen.js"

describe("DotSfen", () => {
  test("escape", () => {
    expect(DotSfen.escape("position sfen 9/9/9/9/9/9/9/9/9 b - 1")).toEqual("position.sfen.9/9/9/9/9/9/9/9/9.b.-.1")
    expect(DotSfen.escape("foo")).toEqual("foo")
  })

  test("unescape", () => {
    expect(DotSfen.unescape("position.sfen.9/9/9/9/9/9/9/9/9.b.-.1")).toEqual("position sfen 9/9/9/9/9/9/9/9/9 b - 1")
    expect(DotSfen.unescape("foo")).toEqual("foo")
  })
})
