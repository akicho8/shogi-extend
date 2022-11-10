import { Gs2 } from "@/components/models/gs2.js"
import _ from "lodash"

export class PiyoSfenLinkCreator {
  static url_for(params) {
    return this.create(params).url
  }

  static create(params) {
    Gs2.__assert__(Gs2.blank_p(params.path), "Gs2.blank_p(params.path)")
    Gs2.__assert__(Gs2.present_p(params.sfen), "Gs2.present_p(params.sfen)")
    return new this(params)
  }

  constructor(params) {
    this.params = params
  }

  get url() {
    const url = new URL("piyoshogi://")
    _.each(this.allowed_params, (v, k) => url.searchParams.set(k, v))
    return url.toString()
  }

  // private

  get all_params() {
    return {
      ...this.params,
      num: this.params.turn,
    }
  }

  get allowed_keys() {
    return ["viewpoint", "num", "sente_name", "gote_name", "game_name", "sfen"]
  }

  get allowed_params() {
    return Gs2.hash_compact(Gs2.hash_slice(this.all_params, ...this.allowed_keys))
  }
}
