import { PiyoShogiUrlCreator } from "@/components/models/piyo_shogi_url_creator.js"

describe("PiyoShogiUrlCreator", () => {
  describe("ClassMethods", () => {
    it("URLをエスケープしていて手数がないのでnumパラメータは入っていない", () => {
      expect(PiyoShogiUrlCreator.url_for({kif_url: "https://example.com/"})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })
    it("手数がある場合は異なるパラメータで埋める", () => {
      expect(PiyoShogiUrlCreator.url_for({kif_url: "https://example.com/", turn: 0})).toEqual("piyoshogi://?num=0&url=https%3A%2F%2Fexample.com%2F")
    })
  })
})
