import { PiyoShogiTypeCurrent } from "@/components/models/piyo_shogi_type_current.js"

describe("PiyoShogiTypeCurrent", () => {
  it("reset", () => {
    PiyoShogiTypeCurrent.reset()
  })
  it("info", () => {
    expect($PiyoShogiTypeCurrent.info.key).toEqual("auto")
  })
})
