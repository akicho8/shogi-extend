import { PiyoShogiTypeCurrent } from "@/components/models/piyo_shogi_type_current.js"

describe("PiyoShogiTypeCurrent", () => {
  test("reset", () => {
    PiyoShogiTypeCurrent.reset()
  })

  test("reload", () => {
    PiyoShogiTypeCurrent.reload()
  })

  test("info", () => {
    expect(PiyoShogiTypeCurrent.info.key).toEqual("auto")
  })
})
