import { KifuVo } from "@/components/models/kifu_vo.js"

describe("KifuVo", () => {
  it("kento_full_url", () => {
    expect(KifuVo.create({sfen: "position sfen startpos", turn: 0, viewpoint: "black"}).kento_full_url).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&viewpoint=black#0")
  })
})
