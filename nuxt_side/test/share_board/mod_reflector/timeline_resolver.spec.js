import { TimelineResolver } from "@/components/ShareBoard/mod_reflector/timeline_resolver.js"

describe("TimelineResolver", () => {
  function case1(attrs) {
    const sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    return TimelineResolver.create({
      old_sfen: sfen,
      old_turn: 0,
      new_sfen: sfen,
      ...attrs,
    })
  }

  test("相対的に下げる", () => {
    const timeline_resolver = case1({old_turn: 5, by: -2})
    expect(timeline_resolver.new_turn).toEqual(3)
    expect(timeline_resolver.turn_diff).toEqual(-2)
    expect(timeline_resolver.turn_step).toEqual(2)
    expect(timeline_resolver.turn_next_p).toEqual(false)
    expect(timeline_resolver.turn_previous_p).toEqual(true)
    expect(timeline_resolver.turn_same_p).toEqual(false)
    expect(timeline_resolver.past_message).toEqual("2手戻しました")
  })

  test("相対的に上げる", () => {
    const timeline_resolver = case1({old_turn: 5, by: 2})
    expect(timeline_resolver.new_turn).toEqual(7)
    expect(timeline_resolver.turn_diff).toEqual(2)
    expect(timeline_resolver.turn_step).toEqual(2)
    expect(timeline_resolver.turn_next_p).toEqual(true)
    expect(timeline_resolver.turn_previous_p).toEqual(false)
    expect(timeline_resolver.turn_same_p).toEqual(false)
    expect(timeline_resolver.past_message).toEqual("2手進めました")
  })

  test("セットする", () => {
    const timeline_resolver = case1({old_turn: 5, to: 3})
    expect(timeline_resolver.new_turn).toEqual(3)
    expect(timeline_resolver.turn_diff).toEqual(-2)
    expect(timeline_resolver.turn_step).toEqual(2)
    expect(timeline_resolver.turn_next_p).toEqual(false)
    expect(timeline_resolver.turn_previous_p).toEqual(true)
    expect(timeline_resolver.turn_same_p).toEqual(false)
    expect(timeline_resolver.past_message).toEqual("3手目に戻しました")
  })

  test("マイナスにはならない", () => {
    const timeline_resolver = case1({old_turn: 5, to: -6})
    expect(timeline_resolver.new_turn).toEqual(0)
    expect(timeline_resolver.turn_diff).toEqual(-5)
    expect(timeline_resolver.turn_step).toEqual(5)
    expect(timeline_resolver.turn_next_p).toEqual(false)
    expect(timeline_resolver.turn_previous_p).toEqual(true)
    expect(timeline_resolver.turn_same_p).toEqual(false)
    expect(timeline_resolver.past_message).toEqual("初期配置に戻しました")
  })

  test("変化しない", () => {
    const timeline_resolver = case1({old_turn: 5, by: 0})
    expect(timeline_resolver.new_turn).toEqual(5)
    expect(timeline_resolver.turn_diff).toEqual(0)
    expect(timeline_resolver.turn_step).toEqual(0)
    expect(timeline_resolver.turn_next_p).toEqual(false)
    expect(timeline_resolver.turn_previous_p).toEqual(false)
    expect(timeline_resolver.turn_same_p).toEqual(true)
    expect(timeline_resolver.past_message).toEqual("5手目に戻しました")
  })

  describe("#sfen_go_back_p", () => {
    test("過去の棋譜", () => {
      const old_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
      const new_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f"
      const timeline_resolver = TimelineResolver.create({old_sfen, old_turn: 2, new_sfen, to: 1})
      expect(timeline_resolver.sfen_go_back_p).toEqual(true)
      expect(timeline_resolver.master_sfen).toEqual(old_sfen)
      expect(timeline_resolver.will_message).toEqual("1手目に戻す")
    })

    test("別の世界線の棋譜", () => {
      const old_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
      const new_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
      const timeline_resolver = TimelineResolver.create({old_sfen, old_turn: 2, new_sfen, to: 1})
      expect(timeline_resolver.sfen_go_back_p).toEqual(false)
      expect(timeline_resolver.master_sfen).toEqual(new_sfen)
      expect(timeline_resolver.will_message).toEqual("別の棋譜の1手目に移動する")
    })
  })

  test("message_prefix オプションは「別の棋譜の」に勝つ", () => {
    const old_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
    const new_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
    const timeline_resolver = TimelineResolver.create({old_sfen, old_turn: 2, new_sfen, to: 1, message_prefix: "(message_prefix)"})
    expect(timeline_resolver.will_message).toEqual("(message_prefix)1手目に移動する")
  })

  test("fast_forward が無効な場合、本線を考慮しなくなる", () => {
    const old_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
    const new_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f"
    const timeline_resolver = TimelineResolver.create({old_sfen, old_turn: 2, new_sfen, to: 1, fast_forward: false})
    expect(timeline_resolver.master_sfen).toEqual(new_sfen)
  })
})
