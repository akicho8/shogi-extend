import { Xobject } from "@/components/models/core/xobject.js"

describe("Xobject", () => {
  test("blank_p", () => {
    expect(Xobject.blank_p(null)).toEqual(true)
    expect(Xobject.blank_p(undefined)).toEqual(true)
    expect(Xobject.blank_p(false)).toEqual(true)
    expect(Xobject.blank_p("")).toEqual(true)
    expect(Xobject.blank_p([])).toEqual(true)
    expect(Xobject.blank_p({})).toEqual(true)
  })
  test("present_p", () => {
    expect(Xobject.present_p(true)).toEqual(true)
    expect(Xobject.present_p("a")).toEqual(true)
    expect(Xobject.present_p(["a"])).toEqual(true)
    expect(Xobject.present_p({a:0})).toEqual(true)
  })
  test("presence", () => {
    expect(Xobject.presence("")).toEqual(null)
    expect(Xobject.presence("a")).toEqual("a")
  })
})
