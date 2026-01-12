import { OrderFlow } from "@/components/ShareBoard/mod_order/order_flow/order_flow.js"

describe("OrderFlow", () => {
  test("順番方式はV2Operationのみとする", () => {
    const order_flow = OrderFlow.create(["a", "b", "c"])
    expect(order_flow.inspect).toEqual("[黒開始:abcb] [白開始:babc] [観:] [替:o]")
  })

  describe("対局者または観戦者を追加する", () => {
    test("対局者が空なので全員を対局者とする", () => {
      const order_flow = OrderFlow.create()
      expect(order_flow.inspect).toEqual("[黒開始:] [白開始:] [観:] [替:o]")
      order_flow.auto_users_set(["a", "b"])
      expect(order_flow.inspect).toEqual("[黒開始:ab] [白開始:ba] [観:] [替:o]")
    })

    test("対局者がいるので対局者を除いて観戦者にする", () => {
      const order_flow = OrderFlow.create(["a"])
      expect(order_flow.inspect).toEqual("[黒開始:a?] [白開始:?a] [観:] [替:o]")
      order_flow.auto_users_set(["a", "b"])
      expect(order_flow.inspect).toEqual("[黒開始:a?] [白開始:?a] [観:b] [替:o]")
    })
  })

  test("name_to_turns_hash", () => {
    const order_flow = OrderFlow.create(["a", "b", "c"])
    expect(order_flow.name_to_turns_hash(1)).toEqual({b: [0, 2], a: [1], c: [3]})
  })

  test("name_to_object_hash", () => {
    const order_flow = OrderFlow.create(["a", "b", "c"])
    expect(!!order_flow.name_to_object_hash["a"]).toEqual(true)
  })

  test("hash", () => {
    const order_flow = OrderFlow.create(["a", "b", "c"])
    expect(order_flow.hash).toEqual("4c2a99fde3621eb46b9893b26cb8d94a")
  })

  describe("auto_users_set_with_voted_hash", () => {

    test("両チームに分かれていてcさんは投票していないので観戦者になる", () => {
      const order_flow = OrderFlow.create()
      order_flow.auto_users_set_with_voted_hash(["a", "b", "c"], {a:0, b:1})
      expect(order_flow.inspect).toEqual("[黒開始:ab] [白開始:ba] [観:c] [替:o]")
    })

    test("黒に偏っている場合", () => {
      const order_flow = OrderFlow.create()
      order_flow.auto_users_set_with_voted_hash(["a", "b", "c"], {a:0, b:0})
      expect(order_flow.inspect).toEqual("[黒開始:a?b?] [白開始:?a?b] [観:c] [替:o]")
    })

    test("誰も投票していない場合", () => {
      const order_flow = OrderFlow.create()
      order_flow.auto_users_set_with_voted_hash(["a", "b", "c"], {})
      expect(order_flow.inspect).toEqual("[黒開始:] [白開始:] [観:a,b,c] [替:o]")
    })
  })

  test("all_move_to_watcher", () => {
    const order_flow = OrderFlow.create(["a", "b"])
    order_flow.no_entry_user_only_watch_users_set(["c"]) // 観戦者をセットする
    order_flow.all_move_to_watcher()                                   // 全員を観戦者にする
    expect(order_flow.inspect).toEqual("[黒開始:] [白開始:] [観:c,a,b] [替:o]")
  })
})
