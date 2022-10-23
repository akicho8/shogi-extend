import { OrderUnit } from "@/components/ShareBoard/order_mod/order_unit/order_unit.js"

describe("OrderUnit", () => {
  test("順番方式の相互変換ができる", () => {
    const order_unit = OrderUnit.create(["a", "b", "c"])
    expect(order_unit.inspect).toEqual("[黒開始:abcb] [白開始:babc] [観:] [整:true] [替:o] (O2State)")

    order_unit.state_switch_to("to_o1_state")
    expect(order_unit.inspect).toEqual("[黒開始:abc] [白開始:abc] [観:] [整:true] [替:x] (O1State)")

    order_unit.state_switch_to("to_o2_state")
    expect(order_unit.inspect).toEqual("[黒開始:abcb] [白開始:babc] [観:] [整:true] [替:o] (O2State)")
  })
  describe("対局者または観戦者を追加する", () => {
    test("対局者が空なので全員を対局者とする", () => {
      const order_unit = OrderUnit.create()
      expect(order_unit.inspect).toEqual("[黒開始:] [白開始:] [観:] [整:false] [替:o] (O2State)")
      order_unit.auto_users_set(["a", "b"], {with_shuffle: false})
      expect(order_unit.inspect).toEqual("[黒開始:ab] [白開始:ba] [観:] [整:true] [替:o] (O2State)")
    })
    test("対局者がいるので対局者を除いて観戦者にする", () => {
      const order_unit = OrderUnit.create(["a"])
      expect(order_unit.inspect).toEqual("[黒開始:a?] [白開始:?a] [観:] [整:false] [替:o] (O2State)")
      order_unit.auto_users_set(["a", "b"])
      expect(order_unit.inspect).toEqual("[黒開始:a?] [白開始:?a] [観:b] [整:false] [替:o] (O2State)")
    })
  })
  test("name_to_turns_hash", () => {
    const order_unit = OrderUnit.create(["a", "b", "c"])
    expect(order_unit.name_to_turns_hash(1)).toEqual({b: [0, 2], a: [1], c: [3]})
  })
  test("name_to_object_hash", () => {
    const order_unit = OrderUnit.create(["a", "b", "c"])
    expect(!!order_unit.name_to_object_hash["a"]).toEqual(true)
  })
  test("hash", () => {
    const order_unit = OrderUnit.create(["a", "b", "c"])
    expect(order_unit.hash).toEqual("cc4ec9d81da1bcfb4795b2617ef14d78")
  })
})
