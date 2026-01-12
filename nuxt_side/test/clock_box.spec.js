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

  test("reset", () => {
    const clock_box = new ClockBox()
    clock_box.reset()
  })

  test("clock_switch", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.clock_switch()
  })

  test("tap_on", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.tap_on(0)
    clock_box.tap_on(1)
  })

  test("location_to", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.location_to(0)
    clock_box.location_to(1)
  })

  test("generation_next", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.generation_next(-1)
  })

  test("tick", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.tick()
  })

  test("main_sec_set", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.main_sec_set(1)
    expect(clock_box.single_clocks[0].main_sec).toEqual(1)
    expect(clock_box.single_clocks[1].main_sec).toEqual(1)
  })

  test("play_handle pause_handle resume_handle stop_handle", () => {
    const clock_box = new ClockBox({initial_turn: 0})
    clock_box.play_handle()
    clock_box.pause_handle()
    clock_box.resume_handle()
    clock_box.stop_handle()
  })
})
