import { PiyoUrlLinkCreator } from "@/components/models/piyo_url_link_creator.js"

describe("PiyoUrlLinkCreator", () => {
  describe("ClassMethods", () => {
    const kif_url = "https://example.com/"

    test("エスケープしている", () => {
      expect(PiyoUrlLinkCreator.url_for({kif_url: kif_url})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })

    test("手数がない", () => {
      expect(PiyoUrlLinkCreator.url_for({kif_url: kif_url})).toEqual("piyoshogi://?url=https%3A%2F%2Fexample.com%2F")
    })

    test("手数がある", () => {
      expect(PiyoUrlLinkCreator.url_for({kif_url: kif_url, turn: 2})).toEqual("piyoshogi://?num=2&url=https%3A%2F%2Fexample.com%2F")
    })
  })
})
