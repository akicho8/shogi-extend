import { Xtime } from "@/components/models/core/xtime.js"

describe("Xtime", () => {
  test("xtime_format_human_hms", () => {
    expect(Xtime.xtime_format_human_hms(0)).toEqual("0秒")
    expect(Xtime.xtime_format_human_hms(90)).toEqual("1分30秒")
    expect(Xtime.xtime_format_human_hms(60*59)).toEqual("59分0秒")
    expect(Xtime.xtime_format_human_hms(60*60)).toEqual("1時間0分")
  })
})
