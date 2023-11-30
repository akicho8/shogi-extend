import { SimpleCache } from "@/components/models/simple_cache.js"

describe("SimpleCache", () => {
  it("fetch", () => {
    const simple_cache = new SimpleCache()
    expect(simple_cache.fetch("foo", () => 0)).toEqual(0)
    expect(simple_cache.fetch("foo", () => 1)).toEqual(0)
  })
  it("read/write", () => {
    const simple_cache = new SimpleCache()
    simple_cache.write("foo", 0)
    expect(simple_cache.read("foo")).toEqual(0)
  })
  it("exist_p", () => {
    const simple_cache = new SimpleCache()
    simple_cache.write("foo", false)
    expect(simple_cache.exist_p("foo")).toEqual(true)
  })
  it("delete", () => {
    const simple_cache = new SimpleCache()
    simple_cache.write("foo", 0)
    simple_cache.delete("foo")
    expect(simple_cache.read("foo")).toEqual(undefined)
  })
})
