import { ClockBox } from "@/components/models/clock_box/clock_box.js"

describe("ClockBox", () => {
  test("works", () => {
    const clock_box = new ClockBox({
      initial_main_sec:  5,
      initial_read_sec:  5,
      initial_extra_sec: 0,
      every_plus:        0,
      initial_turn: 0,
    })

    clock_box.reset()

    expect(clock_box.current_location.key).toEqual("black")
    clock_box.generation_next(-1)
    clock_box.clock_switch()

    expect(clock_box.current_location.key).toEqual("white")
    clock_box.generation_next(-1)
    clock_box.generation_next(-1)

    expect(clock_box.single_clocks[0].rest).toEqual(9)
    expect(clock_box.single_clocks[1].rest).toEqual(8)
  })

  test("duplicate", () => {
    const clock_box = new ClockBox()
    const instance = clock_box.duplicate
  })
})
