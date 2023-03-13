import { Xstring } from "./xstring.js"
import { Xhash } from "./xhash.js"
import _ from "lodash"

export const Xquery = {
  // expect(Xquery.query_compact("a:b c").toEqual("a:b"))
  query_compact(str) {
    const hash = this.query_hash_from_str(str)
    const compacted_hash = Xhash.hash_compact(hash)
    return this.query_hash_to_str(compacted_hash)
  },

  // expect(Xquery.query_str_merge("a:b c:d", {c:"x"})).toEqual("a:b c:x")
  query_str_merge(str, params) {
    const hash = this.query_hash_from_str(str)
    _.each(params, (v, k) => hash[k] = v)
    return this.query_hash_to_str(hash)
  },

  // expect(Xquery.query_hash_from_str("a:b c:d")).toEqual({a:"b", c:"d"})
  query_hash_from_str(str) {
    const queries = Xstring.str_split(str || "")
    // const all = queries.filter(e => e.match(/.+:.+/))
    const pair_values = queries.map(e => Xstring.str_split(e, /:/))
    const hash = pair_values.reduce((a, [k, v]) => ({...a, [k]: v}), {})
    return hash
  },

  // expect(Xquery.query_hash_to_str({a:"b", c:"d"})).toEqual("a:b c:d")
  query_hash_to_str(hash) {
    return _.map(hash, (v, k) => [k, v].join(":")).join(" ")
  },
}
