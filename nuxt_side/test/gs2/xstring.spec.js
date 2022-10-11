import { Xstring } from "@/components/models/core/xstring.js"

describe("Xstring", () => {
  test("str_constantize", () => {
    expect(Xstring.str_constantize("Object")).toEqual(Object)
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
  test("str_split", () => {
    expect(Xstring.str_split("a b")).toEqual(["a", "b"])
    expect(Xstring.str_split("a,b,a", /,/)).toEqual(["a", "b", "a"])
    expect(Xstring.str_split("", /,/)).toEqual([])
  })
  test("str_truncate", () => {
    expect(Xstring.str_truncate("12345", {length: 4})).toEqual("1...")
  })
  test("str_to_hash_number", () => {
    expect(Xstring.str_to_hash_number("a")).toEqual(97)
    expect(Xstring.str_to_hash_number("aa")).toEqual(97 + 97)
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
  test("kanji_hankaku_number_format", () => {
    expect(Xstring.kanji_hankaku_number_format("変換〇一二三四五六七八九")).toEqual("変換0123456789")
  })
  test("str_normalize_for_ac", () => {
    expect(Xstring.str_normalize_for_ac("Ａ四")).toEqual("a4")
  })
  test("str_to_md5", () => {
    expect(Xstring.str_to_md5("a")).toEqual("0cc175b9c0f1b6a831c399e269772661")
  })
})
