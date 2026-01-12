import { EndingContext } from "@/components/ShareBoard/mod_resign/ending_context.js"

describe("EndingContext", () => {
  test("#m_body", () => {
    const params = {
      my_location_key: "black",
      win_location_key: "black",
      ending_route_key: "er_manual_normal",
      teams_hash: { black: "a,b", white: "c,d" },
      illegal_hv_list: [],
    }
    expect(EndingContext.create(params).m_subject).toEqual("終局")
    expect(EndingContext.create(params).m_body).toEqual("投了で☗の勝ちです")
    expect(EndingContext.create(params).x_talk).toEqual("負けました")
  })
})
