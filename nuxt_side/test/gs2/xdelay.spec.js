import { Xdelay } from "@/components/models/core/xdelay.js"

describe("Xdelay", () => {
  test("delay_block", () => {
    expect(Xdelay.delay_block(-1, () => {})).toEqual(null)
    expect(Xdelay.delay_block(0, () => {})).toEqual(null)
    expect(Xdelay.delay_block(1, () => {}) != null).toEqual(true)
  })
  test("delay_stop", () => {
    const id = Xdelay.delay_block(60, () => {})
    Xdelay.delay_stop(id)
  })
  test("callback_later", () => {
    Xdelay.callback_later(() => {})
  })
})
