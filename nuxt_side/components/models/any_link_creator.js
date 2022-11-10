import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"
const QueryString = require("qs")

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
    return [
      this.base_url,
      QueryString.stringify(this.allowed_params, {
        addQueryPrefix: true,
        skipNulls: true,
        format: "RFC3986",
      }),
      this.tail_hash,
    ].join("")
  }

  // private

  get allowed_params() {
    const all_params = {...this.params, ...this.transform_params}
    const compacted_params = Gs2.hash_compact(all_params)
    return Gs2.hash_slice(compacted_params, ...this.allowed_keys)
  }
}
