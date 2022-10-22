import { MedalVo } from "@/components/ShareBoard/toryo/medal_vo.js"

describe("MedalVo", () => {
  it("works", () => {
    const object = new MedalVo({alice: 6}, "alice")
    expect(object.count).toEqual(6)
    expect(object.exist_p).toEqual(true)
    expect(object.count_lteq_max).toEqual(false)
    expect(object.visible_medal_text).toEqual("⭐")
  })
})
