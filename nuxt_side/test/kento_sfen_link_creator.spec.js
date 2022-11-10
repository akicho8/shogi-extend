import { KentoSfenLinkCreator } from "@/components/models/kento_sfen_link_creator.js"

describe("KentoSfenLinkCreator", () => {
  describe("ClassMethods", () => {
    const sfen_no_moves = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1"
    const sfen_moves    = "position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 8h2b+"

    it("引数をエスケープしている", () => {
      expect(KentoSfenLinkCreator.url_for({sfen: sfen_no_moves})).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1")
    })
    it("movesがない", () => {
      expect(KentoSfenLinkCreator.url_for({sfen: sfen_no_moves})).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1")
    })
    it("movesがある", () => {
      expect(KentoSfenLinkCreator.url_for({sfen: sfen_moves})).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&moves=7g7f.3c3d.8h2b%2B")
    })
    it("手数がある", () => {
      expect(KentoSfenLinkCreator.url_for({turn: 2, sfen: sfen_no_moves})).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1#2")
    })
  })
})
