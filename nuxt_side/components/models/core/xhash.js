import _ from "lodash"
import { Xobject } from "./xobject.js"

export const Xhash = {
  // {a: 1, b: null, c:undefined, d: ""} => {a: 1, d: ""}
  hash_compact(hash) {
    return _.reduce(hash, (a, val, key) => {
      if (val == null) {
      } else {
        a[key] = val
      }
      return a
    }, {})
  },

  // {a: 1, b: null, c:undefined, d: ""} => {a: 1}
  hash_compact_blank(hash) {
    return _.reduce(hash, (a, val, key) => {
      if (Xobject.present_p(val)) {
        a[key] = val
      }
      return a
    }, {})
  },

  // const hash = { a: 1, b: 1, }
  // const value = Xhash.hash_delete(hash, "a")
  // hash  // => {b: 1}
  // value // => 1
  hash_delete(hash, key) {
    const value = hash[key]
    delete hash[key]
    return value
  },

  // const hash = { a: 1, b: 1, c: 1, }
  // const value = Xhash.hash_extract_self(hash, "a", "b", "d")
  // expect(hash).toEqual({c: 1})
  // expect(value).toEqual({a: 1, b: 1})
  hash_extract_self(hash, ...keys) {
    const result = {}
    keys.forEach(key => {
      const value = this.hash_delete(hash, key)
      if (value != null) {
        result[key] = value
      }
    })
    return result
  }
}
