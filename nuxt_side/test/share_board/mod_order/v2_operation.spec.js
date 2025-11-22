import { V2Operation } from "@/components/ShareBoard/mod_order/order_flow/v2_operation.js"
import { Item } from "@/components/ShareBoard/mod_order/order_flow/item.js"
import { Location } from "shogi-player/components/models/location.js"

describe("V2Operation", () => {
  test("swap_run", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b"), Item.create("d")]])
    object.swap_run()
    expect(object.black_start_order_uniq_users.map(e => e.to_s)).toEqual(["b", "a", "d", "c"])
  })
  test("turn_to_item", () => {
    const f = turn => {
      const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
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
  test("user_name_reject", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
    object.user_name_reject("c")
    expect(object.simple_teams).toEqual([["a"], ["b"]])
  })
  test("simple_teams", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
    expect(object.simple_teams).toEqual([["a", "c"], ["b"]])
  })
  test("real_order_users_to_s", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
    expect(object.real_order_users_to_s(1, 0)).toEqual("abcb")
  })
  test("shuffle_all", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
    object.shuffle_all()
  })
  test("teams_each_shuffle", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
    object.teams_each_shuffle()
  })
  test("team_member_count", () => {
    const object = new V2Operation([[Item.create("a"), Item.create("c")], [Item.create("b")]])
    expect(object.team_member_count(Location.fetch("black"))).toEqual(2)
    expect(object.team_member_count(Location.fetch("white"))).toEqual(1)
  })
  test("flat_uniq_users_sole", () => {
    const object = new V2Operation([[Item.create("a")], []])
    expect(object.flat_uniq_users_sole.user_name).toEqual("a")
  })
})
