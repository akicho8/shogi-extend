import { PiyoUrlCreator } from "@/components/models/piyo_url_creator.js"

describe("PiyoUrlCreator", () => {
  describe("ClassMethods", () => {
    const kif_url = "https://example.com/"

    it("エスケープしている", () => {
      expect(PiyoUrlCreator.url_for({kif_url: kif_url})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })
    it("手数がない", () => {
      expect(PiyoUrlCreator.url_for({kif_url: kif_url})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })
    it("手数がある", () => {
      expect(PiyoUrlCreator.url_for({kif_url: kif_url, turn: 2})).toEqual("piyoshogi://?num=2&url=https%3A%2F%2Fexample.com%2F")
    })
  })
})
