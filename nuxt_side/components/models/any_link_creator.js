import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"
const QueryString = require("query-string")

export class AnyLinkCreator {
  static url_for(...args) {
    return this.create(...args).url
  }

  static create(params) {
    return new this(params)
  }

  constructor(params) {
    this.params = params
  }

  get url() {
    return QueryString.stringifyUrl({
      url: this.base_url,
      query: this.allowed_params,
      fragmentIdentifier: this.tail_hash,
    })
  }

  // private

  get allowed_params() {
    const all_params = {...this.params, ...this.transform_params}
    const compacted_params = Gs2.hash_compact(all_params)
    return Gs2.hash_slice(compacted_params, ...this.allowed_keys)
  }
}
