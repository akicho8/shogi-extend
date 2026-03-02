import { TimeHelper } from "@/components/models/time_helper.js"

describe("TimeHelper", () => {
  test("create", () => {
    expect(TimeHelper.create("2000-01-02 11:22:33").format("YYYY-MM-DD HH:mm:ss")).toEqual("2000-01-02 11:22:33")
  })

  test("current_ms", () => {
    TimeHelper.current_ms()
  })

  test("format_row", () => {
    expect(TimeHelper.format_row("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })

  test("format_diff", () => {
    expect(TimeHelper.format_diff("2000-01-02 11:22:33").includes("年前")).toEqual(true)
  })

  test("format_md_or_ymd", () => {
    expect(TimeHelper.format_md_or_ymd("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })

  test("format_ymd", () => {
    expect(TimeHelper.format_ymd("2000-01-02 11:22:33")).toEqual("2000-01-02")
  })

  test("format_wday_name", () => {
    expect(TimeHelper.format_wday_name("2000-01-02 11:22:33")).toEqual("日")
  })

  test("format_hhmmss", () => {
    expect(TimeHelper.format_hhmmss("2000-01-02 11:22:33")).toEqual("11:22:33")
  })
})
