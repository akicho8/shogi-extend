import { TimeUtil } from "@/components/models/time_util.js"

describe("TimeUtil", () => {
  it("format_hhmmss", () => {
    expect(TimeUtil.format_hhmmss("2000-01-01 11:22:33")).toEqual("11:22:33")
  })
})
