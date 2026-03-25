import { EndingContext } from "@/components/ShareBoard/mod_resign/ending_context.js"
import { EndingRouteTestInfo } from "@/components/ShareBoard/mod_resign/ending_route_test_info.js"

describe("EndingContext", () => {
  test("#modal_body", () => {
    const params = {
      my_location_key: "black",
      win_location_key: "black",
      ending_route_key: "er_user_normal_resign",
      role_group_attributes: { black: ["a", "b"], white: ["c", "d"] },
      illegal_hv_list: [],
      resigned_user_name: "c",
    }
    expect(EndingContext.create(params).modal_subject).toEqual("勝ち")
    expect(EndingContext.create(params).modal_body).toEqual("cさんの投了でaさんチームの勝ちです")
    expect(EndingContext.create(params).talk_content).toEqual("負けました")
  })
})
