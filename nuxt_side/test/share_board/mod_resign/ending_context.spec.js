import { EndingContext } from "@/components/ShareBoard/mod_resign/ending_context.js"
import { EndingRouteTestInfo } from "@/components/ShareBoard/mod_resign/ending_route_test_info.js"

describe("EndingContext", () => {
  test("基本", () => {
    const params = {
      my_location_key: "black",
      win_location_key: "black",
      ending_route_key: "er_user_normal_resign",
      role_group_attributes: { black: ["a", "b"], white: ["c", "d"] },
      illegal_hv_list: [],
      resigned_user_name: "c",
    }
    const ending_context = EndingContext.create(params)
    expect(ending_context.modal_subject).toEqual("勝ち")
    expect(ending_context.modal_body).toEqual("cさんの投了でaチームの勝ちです")
    expect(ending_context.talk_content).toEqual("負けました")
    expect(ending_context.win_team_call_name).toEqual("aチーム")
  })

  test("詰み(勝者)", () => {
    const ending_context = EndingRouteTestInfo.fetch("詰み(勝者)").ending_context
    expect(ending_context.modal_subject).toEqual("勝ち")
    expect(ending_context.modal_body).toEqual("(b2)さんが詰まして(b1)チームの勝ちです")
  })

  test("反則からの投了1", () => {
    const ending_context = EndingRouteTestInfo.fetch("反則からの投了1").ending_context
    expect(ending_context.modal_subject).toEqual("勝ち")
    expect(ending_context.modal_body).toEqual("(w2)さんの二歩と打ち歩詰めからの(w1)さんの投了で(b1)チームの勝ちです")
  })

  test("すべてのパターンを試してとりあえずエラーにならないことを確認する", () => {
    EndingRouteTestInfo.values.forEach(e => {
      expect(() => e.ending_context.toast_content).not.toThrow()
      expect(() => e.ending_context.talk_content).not.toThrow()
      expect(() => e.ending_context.modal_subject).not.toThrow()
      expect(() => e.ending_context.modal_body).not.toThrow()
    })
  })
})
