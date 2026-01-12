import { XprofileDecorator } from "@/components/ShareBoard/xprofile/xprofile_decorator.js"

describe("XprofileDecorator", () => {
  test("works", () => {
    const object = new XprofileDecorator("alice", {win_count: 6, lose_count: 4})
    expect(object.win_count).toEqual(6)
    expect(object.exist_p).toEqual(true)
    expect(object.win_count_lteq_max).toEqual(false)
    expect(object.visible_badge_text).toEqual("⭐")
    expect(object.win_rate_human).toEqual("0.600")
  })
})
