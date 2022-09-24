import { Xrand } from "@/components/models/core/xrand.js"
import _ from "lodash"

describe("Xrand", () => {
  test("irange", () => {
    expect(_.isInteger(Xrand.irand())).toEqual(false)
    expect(_.isInteger(Xrand.irand(5))).toEqual(true)
  })
  test("irand_range", () => {
    expect(Xrand.irand_range(5, 5)).toEqual(5)
  })
})
