import { DotSfen } from "@/components/models/dot_sfen.js"

describe("DotSfen", () => {
  it("escape", () => {
    expect(DotSfen.escape("position sfen 9/9/9/9/9/9/9/9/9 b - 1")).toEqual("position.sfen.9/9/9/9/9/9/9/9/9.b.-.1")
    expect(DotSfen.escape("foo")).toEqual("foo")
  })
  it("unescape", () => {
    expect(DotSfen.unescape("position.sfen.9/9/9/9/9/9/9/9/9.b.-.1")).toEqual("position sfen 9/9/9/9/9/9/9/9/9 b - 1")
    expect(DotSfen.unescape("foo")).toEqual("foo")
  })
})
