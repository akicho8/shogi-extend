import { Xtag } from "@/components/models/core/xtag.js"

describe("Xtag", () => {
  test("tags_add", () => {
    expect(Xtag.tags_add(["a", "b", "c"], "d")).toEqual(["a", "b", "c", "d"])
    expect(Xtag.tags_add("a b c", "d")).toEqual(["a", "b", "c", "d"])
    expect(Xtag.tags_add("a b", ["c", "d"])).toEqual(["a", "b", "c", "d"])
    expect(Xtag.tags_add("a a", "b b c c d d")).toEqual(["a", "b", "c", "d"])
  })
  test("tags_remove", () => {
    expect(Xtag.tags_remove(["a", "b", "c"], "c")).toEqual(["a", "b"])
    expect(Xtag.tags_remove("a b c d", "c d")).toEqual(["a", "b"])
  })
})
