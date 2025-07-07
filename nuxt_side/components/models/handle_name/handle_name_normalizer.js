import _ from "lodash"
import { Gs } from "@/components/models/gs.js"

export class HandleNameNormalizer {
  static normalize(name, options = {}) {
    return new this(name, options).normalize
  }

  constructor(name, options) {
    this.name = name ?? ""
    this.options = {
      ...options,
    }
  }

  get normalize() {
    let s = this.name
    s = s.replace(/\u3000/g, " ")
    s = s.replace(/\s+/g, " ")
    s = _.trim(s)
    return s
  }
}
