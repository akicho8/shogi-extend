import { PiyoSfenLinkCreator } from "@/components/models/piyo_sfen_link_creator.js"

describe("PiyoSfenLinkCreator", () => {
  describe("ClassMethods", () => {
    test("works", () => {
      expect(PiyoSfenLinkCreator.url_for({
        sfen: "position sfen startpos",
        turn: 0,
        viewpoint: "black",
        sente_name: "(sente_name)",
        gote_name: "(gote_name)",
        game_name: "(game_name)",
      })).toEqual("piyoshogi://?game_name=%28game_name%29&gote_name=%28gote_name%29&num=0&sente_name=%28sente_name%29&sfen=position%20sfen%20startpos&viewpoint=black")
    })
  })
})
