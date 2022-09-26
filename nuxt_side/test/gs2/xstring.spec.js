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
  test("str_squish", () => {
    expect(Xstring.str_squish("　　a　　b　　")).toEqual("a b")
    expect(Xstring.str_squish(null)).toEqual("")
  })
  test("str_strip", () => {
    expect(Xstring.str_strip(null)).toEqual("")
    expect(Xstring.str_strip("　　a　　b　　")).toEqual("a　　b")
  })
  test("str_to_words", () => {
    expect(Xstring.str_to_words("")).toEqual([])
    expect(Xstring.str_to_words(null)).toEqual([])
    expect(Xstring.str_to_words(" 　 a 　 a,b 　 c 　 ")).toEqual(["a", "a", "b", "c"])
  })
  test("str_to_tags", () => {
    expect(Xstring.str_to_tags("")).toEqual([])
    expect(Xstring.str_to_tags(null)).toEqual([])
    expect(Xstring.str_to_tags(" 　 a 　 a,b 　 c 　 ")).toEqual(["a", "b", "c"])
  })
  test("tags_str_toggle", () => {
    expect(Xstring.tags_str_toggle("")).toEqual("")
    expect(Xstring.tags_str_toggle(null)).toEqual("")
    expect(Xstring.tags_str_toggle("a b", "c")).toEqual("a b c")
    expect(Xstring.tags_str_toggle("a b c", "c")).toEqual("a b")
  })
  test("str_truncate", () => {
    expect(Xstring.str_truncate("12345", {length: 4})).toEqual("1...")
  })
  test("str_to_hash_number", () => {
    expect(Xstring.str_to_hash_number("a")).toEqual(97)
    expect(Xstring.str_to_hash_number("aa")).toEqual(97 + 97)
  })
})
