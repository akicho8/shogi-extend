import { TimeUtil } from "@/components/models/time_util.js"

describe("TimeUtil", () => {
  test("create", () => {
    expect(TimeUtil.create("2000-01-02 11:22:33").format("YYYY-MM-DD HH:mm:ss")).toEqual("2000-01-02 11:22:33")
  })

  test("current_ms", () => {
    TimeUtil.current_ms()
  })

  test("format_row", () => {
    expect(TimeUtil.format_row("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })

  test("format_diff", () => {
    expect(TimeUtil.format_diff("2000-01-02 11:22:33").includes("年前")).toEqual(true)
  })

  test("format_md_or_ymd", () => {
    expect(TimeUtil.format_md_or_ymd("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })

  test("format_ymd", () => {
    expect(TimeUtil.format_ymd("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })

  test("format_wday_name", () => {
    expect(TimeUtil.format_wday_name("2000-01-02 11:22:33")).toEqual("日")
  })

  test("format_hhmmss", () => {
    expect(TimeUtil.format_hhmmss("2000-01-02 11:22:33")).toEqual("11:22:33")
  })
})
