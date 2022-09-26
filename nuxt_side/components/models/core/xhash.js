import _ from "lodash"
import { Xobject } from "./xobject.js"

export const Xhash = {
  // {a: 1, b: null, c:undefined, d: ""} => {a: 1, d: ""}
  hash_compact_if_null(hash) {
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
}
