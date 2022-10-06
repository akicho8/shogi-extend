import { KifuVo } from "@/components/models/kifu_vo.js"

describe("KifuVo", () => {
  it("piyo_url", () => {
    expect(KifuVo.create({sfen: "position sfen startpos", turn: 0, viewpoint: "black"}).piyo_url).toEqual("https://www.studiok-i.net/ps/?viewpoint=black&num=0&sfen=position%20sfen%20startpos")
  })
  it("kento_url", () => {
    expect(KifuVo.create({sfen: "position sfen startpos", turn: 0, viewpoint: "black"}).kento_url).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+b+-+1&viewpoint=black#0")
  })
})
