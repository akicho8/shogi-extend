import { KifuVo } from "@/components/models/kifu_vo.js"

describe("KifuVo", () => {
  const object = KifuVo.create({
    kif_url: "https://example.com/",
    sfen: "position sfen startpos",
    turn: 0,
    viewpoint: "black",
  })

  it("piyo_url",  () => { object.piyo_url })
  it("kento_url", () => { object.kento_url })
  it("sfen_and_turn", () => {
    expect(object.sfen_and_turn).toEqual({sfen: "position sfen startpos", turn: 0})
  })
})
