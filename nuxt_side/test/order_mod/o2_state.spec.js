import { O2State } from "@/components/ShareBoard/order_mod/order_unit/o2_state.js"
import { Item } from "@/components/ShareBoard/order_mod/order_unit/item.js"

describe("O2State", () => {
  test("swap_run", () => {
    const object = new O2State([[Item.create("a"), Item.create("c")], [Item.create("b"), Item.create("d")]])
    object.swap_run()
    expect(object.black_start_order_uniq_users.map(e => e.to_s)).toEqual(["b", "a", "d", "c"])
  })
  test("turn_to_item", () => {
    const f = turn => {
      const object = new O2State([[Item.create("a"), Item.create("c")], [Item.create("b")]])
      return object.turn_to_item(turn, 2, 1).user_name
    }
    expect(f(-1)).toEqual("c")
    expect(f(0)).toEqual("b")
    expect(f(1)).toEqual("a")
    expect(f(2)).toEqual("b")
    expect(f(3)).toEqual("a")
    expect(f(4)).toEqual("b")
    expect(f(5)).toEqual("c")
    expect(f(6)).toEqual("b")
    expect(f(7)).toEqual("c")
    expect(f(8)).toEqual("b")
    expect(f(9)).toEqual("a")
    expect(f(10)).toEqual("b")
    expect(f(11)).toEqual("a")
  })
})
