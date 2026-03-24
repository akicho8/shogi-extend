import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"

export class RoleGroup {
  static create(attributes) {
    return new this(attributes)
  }

  static get attribute_keys() {
    return [
      "black",
      "white",
      "other",
      "member",
    ]
  }

  constructor(attributes) {
    this.constructor.attribute_keys.forEach(key => {
      this[key] = attributes[key] ?? []
    })
    Object.freeze(this)
  }

  get to_url_hash() {
    const hv = {}
    _.each(this.attributes, (value, key) => {
      hv[key] = value.join(",")
    })
    return hv
  }

  get attributes() {
    const hv = {}
    this.constructor.attribute_keys.forEach(key => {
      hv[key] = this[key]
    })
    return hv
  }

  get to_h() {
    return this.attributes
  }

  get inspect() {
    return JSON.stringify(this)
  }

  get to_s_debug() {
    let hv = {
      "☗側": this.black.join(","),
      "☖側": this.white.join(","),
      "観戦": this.other.join(","),
      "面子": this.member.join(","),
    }
    hv = GX.hash_compact_blank(hv)
    return _.map(hv, (v, k) => `${k}: ${v}\n`).join("")
  }
}
