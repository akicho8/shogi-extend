import { Xquery } from "@/components/models/core/xquery.js"

describe("Xquery", () => {
  test("query_compact", () => {
    expect(Xquery.query_compact("a:b c")).toEqual("a:b")
  })
  test("query_str_merge", () => {
    expect(Xquery.query_str_merge("a:b c:d", {c:"x"})).toEqual("a:b c:x")
  })
  test("query_hash_from_str", () => {
    expect(Xquery.query_hash_from_str("a:b c:d")).toEqual({a:"b", c:"d"})
  })
  test("query_hash_to_str", () => {
    expect(Xquery.query_hash_to_str({a:"b", c:"d"})).toEqual("a:b c:d")
  })
})
