import { KentoVo } from "@/components/models/kento_vo.js"

describe("KentoVo", () => {
  it("turn_guess", () => {
    expect(KentoVo.create("https://www.kento-shogi.com/?moves=2g2f.3c3d#118").turn_guess).toEqual(118)
  })
})
