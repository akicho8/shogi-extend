import _ from "lodash"
import { GX } from "@/components/models/gx.js"

export class SfenSyncParamsWrapper {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    // this.params = params
    Object.assign(this, params)
  }
}
