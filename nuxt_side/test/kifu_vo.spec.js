import { KifuVo } from "@/components/models/kifu_vo.js"

describe("KifuVo", () => {
  const object = KifuVo.create({
    kif_url: "https://example.com/",
    sfen: "position sfen startpos",
    turn: 0,
    viewpoint: "black",
  })

  test("piyo_url",  () => {
    expect(object.piyo_url).toEqual("piyoshogi://?num=0&url=https%3A%2F%2Fexample.com%2F&viewpoint=black")
  })

  test("kento_url", () => {
    expect(object.kento_url).toEqual("https://www.kento-shogi.com/?initpos=lnsgkgsnl%2F1r5b1%2Fppppppppp%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL%20b%20-%201&viewpoint=black")
  })

  test("sfen_and_turn", () => {
    expect(object.sfen_and_turn).toEqual({sfen: "position sfen startpos", turn: 0})
  })
})
