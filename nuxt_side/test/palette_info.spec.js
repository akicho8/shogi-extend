import { PaletteInfo } from "@/components/models/palette_info.js"

describe("PaletteInfo", () => {
  test("works", () => {
    expect(PaletteInfo.fetch(0).key).toEqual("link")
  })
})
