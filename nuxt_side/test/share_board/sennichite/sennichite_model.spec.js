import { SennichiteModel } from "@/components/ShareBoard/sennichite/sennichite_model.js"
import _ from "lodash"

describe("SennichiteModel", () => {
  describe("ClassMethods", () => {
    test("create", () => {
      const object = SennichiteModel.create()
      expect(_.isObject(object)).toEqual(true)
    })
  })
  describe("InstanceMethods", () => {
    test("reset", () => {
      const object = SennichiteModel.create()
      object.update("foo")
      object.reset()
      expect(object.counts_hash).toEqual({})
    })
    test("available_p", () => {
      const object = SennichiteModel.create()
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
  })
})
