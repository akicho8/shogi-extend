import { Xinteger } from "@/components/models/core/xinteger.js"

describe("Xinteger", () => {
  test("imodulo", () => {
    expect(Xinteger.imodulo(-1, 3)).toEqual(2)
    expect(Xinteger.imodulo(4, 3)).toEqual(1)
  })
  test("idiv", () => {
    expect(Xinteger.idiv(-10, 3)).toEqual(-4)
  })
  test("even_p", () => {
    expect(Xinteger.even_p(0)).toEqual(true)
    expect(Xinteger.even_p(1)).toEqual(false)
  })
  test("odd_p", () => {
    expect(Xinteger.odd_p(0)).toEqual(false)
    expect(Xinteger.odd_p(1)).toEqual(true)
  })
  test("gcd", () => {
    expect(Xinteger.gcd(12, 16)).toEqual(4)
  })
  test("lcm", () => {
    expect(Xinteger.lcm(4, 6)).toEqual(12)
  })
  test("iclamp", () => {
    expect(Xinteger.iclamp(0, 1, 2)).toEqual(1)
    expect(Xinteger.iclamp(3, 1, 2)).toEqual(2)
  })
})
