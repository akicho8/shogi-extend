import { PerpetualCop } from "@/components/ShareBoard/perpetual/perpetual_cop.js"
import _ from "lodash"

describe("PerpetualCop", () => {
  describe("ClassMethods", () => {
    test("create", () => {
      const object = PerpetualCop.create()
      expect(_.isObject(object)).toEqual(true)
    })
  })

  test("reset$", () => {
    const object = PerpetualCop.create()
    object.increment$("foo")
    object.reset$()
    expect(object.counts_hash).toEqual({})
  })

  test("available_p", () => {
    const object = PerpetualCop.create()
    object.increment$("foo")
    expect(object.count).toEqual(1)
    expect(object.keys_count).toEqual(1)
    object.increment$("foo")
    expect(object.count).toEqual(2)
    expect(object.keys_count).toEqual(1)
    object.increment$("foo")
    expect(object.available_p("foo")).toEqual(false)
    object.increment$("foo")
    expect(object.available_p("foo")).toEqual(true)
  })

  test("inspect", () => {
    const object = PerpetualCop.create()
    object.increment$("foo")
    object.increment$("foo")
    expect(object.inspect).toEqual("trigger_on_n_times: 4, count: 2, keys_count: 1")
  })
})
