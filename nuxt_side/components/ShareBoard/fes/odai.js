import { Gs2 } from "@/components/models/gs2.js"
import { Location } from "shogi-player/components/models/location.js"

export class Odai {
  static create(...args) {
    return new this(...args)
  }

  static from_json(json) {
    const object = this.create()
    object.from_json(json)
    return object
  }

  constructor() {
    this.subject = ""
    this.items = ["", ""]
  }

  get valid_p() {
    return [this.subject, ...this.items].every(e => Gs2.present_p(e))
  }

  get invalid_p() {
    return !this.valid_p
  }

  get hash() {
    return Gs2.str_to_md5([this.subject, ...this.items].join("/"))
  }

  toJSON() {
    return {
      subject: this.subject,
      items: this.items,
    }
  }

  from_json(other) {
    this.subject = other.subject
    this.items = other.items
  }
}
