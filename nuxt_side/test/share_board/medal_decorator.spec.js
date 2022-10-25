import { MedalDecorator } from "@/components/ShareBoard/medal/medal_decorator.js"

describe("MedalDecorator", () => {
  it("works", () => {
    const object = new MedalDecorator({alice: 6}, "alice")
    expect(object.count).toEqual(6)
    expect(object.exist_p).toEqual(true)
    expect(object.count_lteq_max).toEqual(false)
    expect(object.visible_medal_text).toEqual("⭐")
  })
})
