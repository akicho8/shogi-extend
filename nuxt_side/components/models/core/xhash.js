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
  hash_compact_if_blank(hash) {
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
}
