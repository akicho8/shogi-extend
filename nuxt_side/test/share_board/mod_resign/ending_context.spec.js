import { EndingContext } from "@/components/ShareBoard/mod_resign/ending_context.js"

describe("EndingContext", () => {
  test("#modal_body", () => {
    const params = {
      my_location_key: "black",
      win_location_key: "black",
      ending_route_key: "er_user_normal_resign",
      role_group: { black: "a,b", white: "c,d" },
      illegal_hv_list: [],
    }
    expect(EndingContext.create(params).modal_subject).toEqual("終局")
    expect(EndingContext.create(params).modal_body).toEqual("投了で☗の勝ちです")
    expect(EndingContext.create(params).talk_content).toEqual("負けました")
  })
})
