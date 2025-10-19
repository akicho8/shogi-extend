import { FurigomaPack } from "@/components/models/furigoma/furigoma_pack.js"

describe("FurigomaPack", () => {
  test("1回振るごとに反転する", () => {
    const object = new FurigomaPack({furigoma_random_key: "force_true", shakashaka_count: 5})
    expect(object.inspect).toEqual("[0] 歩歩歩歩歩 歩が5枚 false")
    object.shaka_and_shaka()
    expect(object.inspect).toEqual("[5] ととととと と金が5枚 true")
  })

  test("本当のランダム", () => {
    FurigomaPack.call()
  })
})
