import { Xaratio } from "@/components/models/core/xaratio.js"

describe("Xaratio", () => {
  test("aspect_ratio_normalize", () => {
    expect(Xaratio.aspect_ratio_normalize(640, 480)).toEqual([1.3333333333333333, 1])
  })
  test("aspect_ratio_gcd", () => {
    expect(Xaratio.aspect_ratio_gcd(640, 480)).toEqual([4, 3])
  })
})
