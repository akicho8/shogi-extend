import { PiyoSfenLinkCreator } from "@/components/models/piyo_sfen_link_creator.js"

describe("PiyoSfenLinkCreator", () => {
  describe("ClassMethods", () => {
    it("works", () => {
      expect(PiyoSfenLinkCreator.url_for({
        sfen: "position sfen startpos",
        turn: 0,
        viewpoint: "black",
        sente_name: "(sente_name)",
        gote_name: "(gote_name)",
        game_name: "(game_name)",
      })).toEqual("piyoshogi://?viewpoint=black&num=0&sente_name=(sente_name)&gote_name=(gote_name)&game_name=(game_name)&sfen=position%20sfen%20startpos")
    })
  })
})
