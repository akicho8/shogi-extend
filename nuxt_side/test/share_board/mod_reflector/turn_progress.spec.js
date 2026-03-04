import { TurnProgress } from "@/components/ShareBoard/mod_reflector/turn_progress.js"

describe("TurnProgress", () => {
  function case1(attrs) {
    const sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    return TurnProgress.create({
      old_sfen: sfen,
      old_turn: 0,
      new_sfen: sfen,
      ...attrs,
    })
  }

  test("相対的に下げる", () => {
    const turn_progress = case1({old_turn: 5, by: -2})
    expect(turn_progress.new_turn).toEqual(3)
    expect(turn_progress.diff).toEqual(-2)
    expect(turn_progress.step).toEqual(2)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(true)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.past_message).toEqual("2手戻しました")
  })

  test("相対的に上げる", () => {
    const turn_progress = case1({old_turn: 5, by: 2})
    expect(turn_progress.new_turn).toEqual(7)
    expect(turn_progress.diff).toEqual(2)
    expect(turn_progress.step).toEqual(2)
    expect(turn_progress.next_p).toEqual(true)
    expect(turn_progress.previous_p).toEqual(false)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.past_message).toEqual("2手進めました")
  })

  test("セットする", () => {
    const turn_progress = case1({old_turn: 5, to: 3})
    expect(turn_progress.new_turn).toEqual(3)
    expect(turn_progress.diff).toEqual(-2)
    expect(turn_progress.step).toEqual(2)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(true)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.past_message).toEqual("3手目に戻しました")
  })

  test("マイナスにはならない", () => {
    const turn_progress = case1({old_turn: 5, to: -6})
    expect(turn_progress.new_turn).toEqual(0)
    expect(turn_progress.diff).toEqual(-5)
    expect(turn_progress.step).toEqual(5)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(true)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.past_message).toEqual("初期配置に戻しました")
  })

  test("変化しない", () => {
    const turn_progress = case1({old_turn: 5, by: 0})
    expect(turn_progress.new_turn).toEqual(5)
    expect(turn_progress.diff).toEqual(0)
    expect(turn_progress.step).toEqual(0)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(false)
    expect(turn_progress.same_p).toEqual(true)
    expect(turn_progress.past_message).toEqual("0手戻しました")
  })

  describe("#descendant_sfen_p", () => {
    test("過去の棋譜", () => {
      const old_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
      const new_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f"
      const turn_progress = TurnProgress.create({old_sfen, old_turn: 2, new_sfen, to: 1})
      expect(turn_progress.descendant_sfen_p).toEqual(true)
      expect(turn_progress.master_sfen).toEqual(old_sfen)
    })

    test("別の世界線の棋譜", () => {
      const old_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d"
      const new_sfen = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 2g2f"
      const turn_progress = TurnProgress.create({old_sfen, old_turn: 2, new_sfen, to: 1})
      expect(turn_progress.descendant_sfen_p).toEqual(false)
      expect(turn_progress.master_sfen).toEqual(new_sfen)
    })
  })
})
