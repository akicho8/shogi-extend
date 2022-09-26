import { Xobject } from "@/components/models/core/xobject.js"
import _ from "lodash"

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
  test("p", () => {
    expect(_.isFunction(Xobject.p)).toEqual(true)
  })
  test("pp", () => {
    expect(_.isFunction(Xobject.pp)).toEqual(true)
  })
  test("short_inspect", () => {
    expect(Xobject.short_inspect(0)).toEqual("0")
  })
  test("i", () => {
    expect(Xobject.i(0)).toEqual("0")
  })
  test("pretty_inspect", () => {
    expect(Xobject.pretty_inspect(0)).toEqual("0")
  })
  test("a", () => {
    expect(_.isFunction(Xobject.a)).toEqual(true)
  })
})
