import { KentoUrlParser } from "@/components/models/kento_url_parser.js"

describe("KentoUrlParser", () => {
  test("turn_guess", () => {
    const url = "https://www.kento-shogi.com/?moves=2g2f.3c3d#118"
    expect(KentoUrlParser.parse(url).turn_guess).toEqual(118)
  })
})
