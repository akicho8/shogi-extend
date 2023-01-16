import { SntModel } from "@/components/ShareBoard/snt/snt_model.js"
import _ from "lodash"

describe("SntModel", () => {
  describe("ClassMethods", () => {
    test("create", () => {
      const object = SntModel.create()
      expect(_.isObject(object)).toEqual(true)
    })
  })
  describe("InstanceMethods", () => {
    test("reset", () => {
      const object = SntModel.create()
      object.update("foo")
      object.reset()
      expect(object.counts_hash).toEqual({})
    })
    test("available_p", () => {
      const object = SntModel.create()
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
