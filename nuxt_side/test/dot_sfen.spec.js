import { DotSfen } from "@/components/models/dot_sfen.js"

describe("DotSfen", () => {
  it("space_to_dot_replace", () => {
    expect(DotSfen.space_to_dot_replace("a b c")).toEqual("a.b.c")
  })
})
