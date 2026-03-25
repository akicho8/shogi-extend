import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"

// Value Object
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
      const value = attributes[key]
      if (value != null) {
        GX.assert_kind_of_array(value)
      }
      this[key] = value ?? []
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
    return JSON.stringify(this.attributes)
  }

  get to_s_debug() {
    return JSON.stringify(this.attributes)
    // let hv = {
    //   "☗側": this.black.join(","),
    //   "☖側": this.white.join(","),
    //   "観戦": this.other.join(","),
    //   "面子": this.member.join(","),
    // }
    // hv = GX.hash_compact_blank(hv)
    // return _.map(hv, (v, k) => `${k}: ${v}\n`).join("")
  }
}
