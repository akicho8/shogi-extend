import { Xfloat } from "@/components/models/core/xfloat.js"

describe("Xfloat", () => {
  test("number_floor", () => {
    expect(Xfloat.number_floor(-1.5)).toEqual(-2)
  })
  test("number_ceil", () => {
    expect(Xfloat.number_ceil(-1.5)).toEqual(-1)
  })
  test("number_round", () => {
    expect(Xfloat.number_round(-1.5)).toEqual(-1)
  })
  test("number_round_s", () => {
    expect(Xfloat.number_round_s(1.0, 2)).toEqual("1.00")
  })
  test("number_truncate", () => {
    expect(Xfloat.number_truncate(1.23, 1)).toEqual(1.2)
  })
  test("floatx100_percentage", () => {
    expect(Xfloat.floatx100_percentage(0.12345, 2)).toEqual(12.34)
  })
})
