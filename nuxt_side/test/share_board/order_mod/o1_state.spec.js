import { O1State } from "@/components/ShareBoard/order_mod/order_unit/o1_state.js"
import { Item } from "@/components/ShareBoard/order_mod/order_unit/item.js"
import { Location } from "shogi-player/components/models/location.js"

describe("O1State", () => {
  test("swap_run", () => {
    const object = new O1State(["a", "b", "c"].map(e => Item.create(e)))
    object.swap_run()
    expect(object.black_start_order_uniq_users.map(e => e.to_s)).toEqual(["b", "a", "c"])
  })
  test("user_name_reject", () => {
    const object = new O1State(["a", "b", "c"].map(e => Item.create(e)))
    object.user_name_reject("b")
    expect(object.black_start_order_uniq_users.map(e => e.to_s)).toEqual(["a", "c"])
  })
  test("turn_to_item", () => {
    const f = turn => {
      const object = new O1State(["a", "b", "c"].map(e => Item.create(e)))
      return object.turn_to_item(turn, 2, 1).user_name
    }
    expect(f(-1)).toEqual("c")
    expect(f(0)).toEqual("a")
    expect(f(1)).toEqual("b")
    expect(f(2)).toEqual("a")
    expect(f(3)).toEqual("b")
    expect(f(4)).toEqual("c")
    expect(f(5)).toEqual("a")
    expect(f(6)).toEqual("c")
    expect(f(7)).toEqual("a")
  })
  test("real_order_users_to_s", () => {
    const object = new O1State([Item.create("a"), Item.create("b"), Item.create("c")])
    expect(object.real_order_users_to_s(1, 0)).toEqual("abc")
  })
  test("team_member_count", () => {
    const object = new O1State([Item.create("a"), Item.create("b"), Item.create("c")])
    expect(object.team_member_count(Location.fetch("black"))).toEqual(undefined)
    expect(object.team_member_count(Location.fetch("white"))).toEqual(undefined)
  })
})
