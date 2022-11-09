import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

export class PiyoShogiUrlCreator {
  static url_for(params) {
    return this.create(params).url
  }

  static create(params) {
    Gs2.__assert__(Gs2.blank_p(params.path), "Gs2.blank_p(params.path)")
    Gs2.__assert__(Gs2.present_p(params.kif_url), "Gs2.present_p(params.kif_url)")
    return new this(params)
  }

  constructor(params) {
    this.params = params
  }

  get url() {
    const usp = new URLSearchParams()
    _.each(this.allowed_params, (v, k) => usp.set(k, v))
    return `${this.deep_link_prefix}?${usp}`
  }

  // private

  get allowed_params() {
    return Gs2.hash_slice(this.all_params, ...this.allowed_keys)
  }

  get all_params() {
    return Gs2.hash_compact({
      ...this.params,
      num: this.params.turn,
      url: this.params.kif_url,
    })
  }

  get deep_link_prefix() {
    return "piyoshogi://"
  }

  get allowed_keys() {
    return ["viewpoint", "num", "url"]
  }
}
