import { TimeUtil } from "@/components/models/time_util.js"

describe("TimeUtil", () => {
  it("create", () => {
    expect(TimeUtil.create("2000-01-02 11:22:33").format("YYYY-MM-DD HH:mm:ss")).toEqual("2000-01-02 11:22:33")
  })
  it("current_ms", () => {
    TimeUtil.current_ms()
  })
  it("format_row", () => {
    expect(TimeUtil.format_row("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })
  it("format_diff", () => {
    expect(TimeUtil.format_diff("2000-01-02 11:22:33")).toEqual("23年前")
  })
  it("format_md_or_ymd", () => {
    expect(TimeUtil.format_md_or_ymd("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })
  it("format_ymd", () => {
    expect(TimeUtil.format_ymd("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })
  it("format_wday_name", () => {
    expect(TimeUtil.format_wday_name("2000-01-02 11:22:33")).toEqual("日")
  })
  it("format_hhmmss", () => {
    expect(TimeUtil.format_hhmmss("2000-01-02 11:22:33")).toEqual("11:22:33")
  })
})
