import { SennichiteCop } from "@/components/ShareBoard/sennichite/sennichite_cop.js"
import _ from "lodash"

describe("SennichiteCop", () => {
  describe("ClassMethods", () => {
    test("create", () => {
      const object = SennichiteCop.create()
      expect(_.isObject(object)).toEqual(true)
    })
  })
  describe("InstanceMethods", () => {
    test("reset", () => {
      const object = SennichiteCop.create()
      object.update("foo")
      object.reset()
      expect(object.counts_hash).toEqual({})
    })
    test("available_p", () => {
      const object = SennichiteCop.create()
      object.update("foo")
      expect(object.count).toEqual(1)
      expect(object.keys_count).toEqual(1)
      object.update("foo")
      expect(object.count).toEqual(2)
      expect(object.keys_count).toEqual(1)
      object.update("foo")
      expect(object.available_p("foo")).toEqual(false)
      object.update("foo")
      expect(object.available_p("foo")).toEqual(true)
    })
    test("inspect", () => {
      const object = SennichiteCop.create()
      object.update("foo")
      object.update("foo")
      expect(object.inspect).toEqual("trigger_on_n_times: 4, count:2, keys_count: 1")
    })
  })
})
