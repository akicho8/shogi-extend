import { V1Strategy } from "@/components/ShareBoard/mod_order/order_flow/v1_strategy.js"

describe("V1Strategy", () => {
  test("works", () => {
    const f = turn => {
      const object = new V1Strategy(3, turn, 2, 1)
      return object.user_index
    }
    expect(f(-1)).toEqual(2)
    expect(f(0)).toEqual(0)
    expect(f(1)).toEqual(1)
    expect(f(2)).toEqual(0)
    expect(f(3)).toEqual(1)
    expect(f(4)).toEqual(2)
    expect(f(5)).toEqual(0)
    expect(f(6)).toEqual(2)
    expect(f(7)).toEqual(0)
  })
})
