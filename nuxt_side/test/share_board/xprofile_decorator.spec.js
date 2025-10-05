import { XprofileDecorator } from "@/components/ShareBoard/badge/xprofile_decorator.js"

describe("XprofileDecorator", () => {
  it("works", () => {
    const object = new XprofileDecorator({alice: 6}, "alice")
    expect(object.count).toEqual(6)
    expect(object.exist_p).toEqual(true)
    expect(object.count_lteq_max).toEqual(false)
    expect(object.visible_badge_text).toEqual("⭐")
  })
})
