import { XbadgeDecorator } from "@/components/ShareBoard/badge/xbadge_decorator.js"

describe("XbadgeDecorator", () => {
  it("works", () => {
    const object = new XbadgeDecorator({alice: 6}, "alice")
    expect(object.count).toEqual(6)
    expect(object.exist_p).toEqual(true)
    expect(object.count_lteq_max).toEqual(false)
    expect(object.visible_badge_text).toEqual("⭐")
  })
})
