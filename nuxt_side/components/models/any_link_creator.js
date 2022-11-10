import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

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
    const url = new URL(this.base_url)
    _.each(this.allowed_params, (v, k) => url.searchParams.set(k, v))
    if (this.tail_hash != null) {
      url.hash = this.tail_hash
    }
    return url.toString()
  }

  // private

  get allowed_params() {
    const all_params = {...this.params, ...this.transform_params}
    const compacted_params = Gs2.hash_compact(all_params)
    return Gs2.hash_slice(compacted_params, ...this.allowed_keys)
  }

  // TODO: ぴよ将棋 URLSearchParams に対応したら取る
  get url_build_for_piyo() {
    const ary = _.map(this.allowed_params, (v, k) => [k, encodeURIComponent(v)].join("="))
    const query = ary.join("&")
    return `${this.base_url}?${query}`
  }
}
