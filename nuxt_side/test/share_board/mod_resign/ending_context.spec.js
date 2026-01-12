import { EndingContext } from "@/components/ShareBoard/mod_resign/ending_context.js"

describe("EndingContext", () => {
  test("#message", () => {
    const params = {
      my_location_key: "black",
      win_location_key: "black",
      ending_route_key: "er_manual_normal",
      teams_hash: { black: "a,b", white: "c,d" },
    }
    expect(EndingContext.create({...params, ending_route_key: "er_auto_checkmate", win_location_key: "black"}).message).toEqual("詰みで☗の勝ちです")
    expect(EndingContext.create({...params, ending_route_key: "er_auto_checkmate", win_location_key: "white"}).message).toEqual("詰みで☖の勝ちです")
    expect(EndingContext.create({...params, ending_route_key: "er_manual_normal",    win_location_key: "black"}).message).toEqual("投了で☗の勝ちです")
    expect(EndingContext.create({...params, ending_route_key: "er_manual_normal",    win_location_key: "white"}).message).toEqual("投了で☖の勝ちです")
    expect(EndingContext.create({...params, win_location_key: null}).message).toEqual("引き分けです")
  })
})
