import { Xhash } from "@/components/models/core/xhash.js"

const HASH_VALUE1 = {
  a: 0,
  b: 1,
  c: "",
  d: {},
  e: {a: 0},
  f: [],
  g: ["a"],
  h: true,
  i: false,
  j: null,
  k: undefined,
}

describe("Xhash", () => {
  test("hash_compact", () => {
    expect(Xhash.hash_compact(HASH_VALUE1)).toEqual({a: 0, b: 1, c: "", d: {}, e: {a: 0}, f: [], g: ["a"], h: true, i: false})
  })
  test("hash_compact_blank", () => {
    expect(Xhash.hash_compact_blank(HASH_VALUE1)).toEqual({a: 0, b: 1, e: {a:0}, g: ["a"], h: true})
  })
  test("hash_delete", () => {
    const hash = { a: 1, b: 1, }
    const value = Xhash.hash_delete(hash, "a")
    expect(hash).toEqual({b: 1})
    expect(value).toEqual(1)
  })
})
