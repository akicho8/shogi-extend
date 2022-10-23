import { PiyoShogiUtil } from "@/components/models/piyo_shogi_util.js"

describe("PiyoShogiUtil", () => {
  it("app_url", () => {
    // piyoshogi://?viewpoint=black&num=0&url=http://localhost:3000/share-board.kif?abstract_viewpoint=black&turn=0&xbody=cG9zaXRpb24gc2ZlbiBsbnNna2dzbmwvMXI1YjEvcHBwcHBwcHBwLzkvOS85L1BQUFBQUFBQUC8xQjVSMS9MTlNHS0dTTkwgYiAtIDE
    //
    // http://localhost:3000/share-board.kif?abstract_viewpoint=black&turn=0&xbody=cG9zaXRpb24gc2ZlbiBsbnNna2dzbmwvMXI1YjEvcHBwcHBwcHBwLzkvOS85L1BQUFBQUFBQUC8xQjVSMS9MTlNHS0dTTkwgYiAtIDE

    // const params = {
    //   kif_url: "http://localhost:3000/share-board.kif?abstract_viewpoint=black&turn=0&xbody=cG9zaXRpb24gc2ZlbiBsbnNna2dzbmwvMXI1YjEvcHBwcHBwcHBwLzkvOS85L1BQUFBQUFBQUC8xQjVSMS9MTlNHS0dTTkwgYiAtIDE",
    // }
    // expect(PiyoShogiUtil.create(params).app_url).toEqual(118)
  })
})
