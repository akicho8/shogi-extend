import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import { Location } from "shogi-player/components/models/location.js"
import { HandleNameParser } from "@/components/models/handle_name/handle_name_parser.js"

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
  }

  // expect(RoleGroup.create({black: []}).team_name(Location.black)).toEqual("☗")
  // expect(RoleGroup.create({black: ["a"]}).team_name(Location.black)).toEqual("aさん")
  // expect(RoleGroup.create({black: ["a", "b"]}).team_name(Location.black)).toEqual("aさんチーム")
  team_name(location) {
    GX.assert(location)
    const names = this[location.key]
    if (names.length === 0) {
      return location.name
    } else if (names.length === 1) {
      return this.call_name(names[0])
    } else {
      return [this.call_name(names[0]), "チーム"].join("")
    }
  }

  call_name(name) {
    if (name != null) {
      return HandleNameParser.call_name(name)
    }
  }
}
