import { O2Strategy } from "@/components/ShareBoard/mod_order/order_unit/o2_strategy.js"

describe("O2Strategy", () => {
  test("works", () => {
    const f = turn => {
      const object = new O2Strategy([2, 1], turn, 2, 1)
      return [object.team_index, object.user_index]
    }
    expect(f(-1)).toEqual([0, 1])
    expect(f(0)).toEqual([1, 0])
    expect(f(1)).toEqual([0, 0])
    expect(f(2)).toEqual([1, 0])
    expect(f(3)).toEqual([0, 0])
    expect(f(4)).toEqual([1, 0])
    expect(f(5)).toEqual([0, 1])
    expect(f(6)).toEqual([1, 0])
    expect(f(7)).toEqual([0, 1])
    expect(f(8)).toEqual([1, 0])
    expect(f(9)).toEqual([0, 0])
    expect(f(10)).toEqual([1, 0])
    expect(f(11)).toEqual([0, 0])
  })
})
