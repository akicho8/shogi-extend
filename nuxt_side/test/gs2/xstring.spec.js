import { Xstring } from "@/components/models/core/xstring.js"

describe("Xstring", () => {
  test("str_constantize", () => {
    expect(Xstring.str_constantize("Object")).toEqual(Object)
  })
  test("hira_to_kata", () => {
    expect(Xstring.hira_to_kata("あア")).toEqual("アア")
  })
  test("kana_to_hira", () => {
    expect(Xstring.kana_to_hira("あア")).toEqual("ああ")
  })
  test("hankaku_format", () => {
    expect(Xstring.hankaku_format("Ａａ０")).toEqual("Aa0")
  })
  test("str_to_boolean", () => {
    expect(Xstring.str_to_boolean("1")).toEqual(true)
  })
})
