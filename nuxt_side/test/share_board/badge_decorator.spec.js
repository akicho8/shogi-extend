import { BadgeDecorator } from "@/components/ShareBoard/badge/badge_decorator.js"

describe("BadgeDecorator", () => {
  it("works", () => {
    const object = new BadgeDecorator({alice: 6}, "alice")
    expect(object.count).toEqual(6)
    expect(object.exist_p).toEqual(true)
    expect(object.count_lteq_max).toEqual(false)
    expect(object.visible_badge_text).toEqual("⭐")
  })
})
