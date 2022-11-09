import { PiyoShogiUrlCreator } from "@/components/models/piyo_shogi_url_creator.js"

describe("PiyoShogiUrlCreator", () => {
  describe("ClassMethods", () => {
    const kif_url = "https://example.com/"

    it("エスケープしている", () => {
      expect(PiyoShogiUrlCreator.url_for({kif_url: kif_url})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })
    it("手数がない", () => {
      expect(PiyoShogiUrlCreator.url_for({kif_url: kif_url})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })
    it("手数がある", () => {
      expect(PiyoShogiUrlCreator.url_for({kif_url: kif_url, turn: 2})).toEqual("piyoshogi://?num=2&url=https%3A%2F%2Fexample.com%2F")
    })
  })
})
