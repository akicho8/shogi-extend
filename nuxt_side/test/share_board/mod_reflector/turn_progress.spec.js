import { TurnProgress } from "@/components/ShareBoard/mod_reflector/turn_progress.js"

describe("TurnProgress", () => {
  test("相対的に下げる", () => {
    const turn_progress = TurnProgress.create({current: 5, by: -2})
    expect(turn_progress.new_value).toEqual(3)
    expect(turn_progress.diff).toEqual(-2)
    expect(turn_progress.step).toEqual(2)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(true)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.message).toEqual("2手戻しました")
  })

  test("相対的に上げる", () => {
    const turn_progress = TurnProgress.create({current: 5, by: 2})
    expect(turn_progress.new_value).toEqual(7)
    expect(turn_progress.diff).toEqual(2)
    expect(turn_progress.step).toEqual(2)
    expect(turn_progress.next_p).toEqual(true)
    expect(turn_progress.previous_p).toEqual(false)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.message).toEqual("2手進めました")
  })

  test("セットする", () => {
    const turn_progress = TurnProgress.create({current: 5, to: 3})
    expect(turn_progress.new_value).toEqual(3)
    expect(turn_progress.diff).toEqual(-2)
    expect(turn_progress.step).toEqual(2)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(true)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.message).toEqual("3手目に移動しました")
  })

  test("マイナスにはならない", () => {
    const turn_progress = TurnProgress.create({current: 5, to: -6})
    expect(turn_progress.new_value).toEqual(0)
    expect(turn_progress.diff).toEqual(-5)
    expect(turn_progress.step).toEqual(5)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(true)
    expect(turn_progress.same_p).toEqual(false)
    expect(turn_progress.message).toEqual("初期配置に戻しました")
  })

  test("変化しない", () => {
    const turn_progress = TurnProgress.create({current: 5, by: 0})
    expect(turn_progress.new_value).toEqual(5)
    expect(turn_progress.diff).toEqual(0)
    expect(turn_progress.step).toEqual(0)
    expect(turn_progress.next_p).toEqual(false)
    expect(turn_progress.previous_p).toEqual(false)
    expect(turn_progress.same_p).toEqual(true)
    expect(turn_progress.message).toEqual("0手進めました (手数変化なし)")
  })
})
