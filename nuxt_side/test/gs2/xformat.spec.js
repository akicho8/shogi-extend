import { Xformat } from "@/components/models/core/xformat.js"

describe("Xformat", () => {
  test("format", () => {
    expect(Xformat.format("%02d", 1)).toEqual("01")
    expect(Xformat.format("%j", {a:1})).toEqual("{ a: 1 }")
  })
})
