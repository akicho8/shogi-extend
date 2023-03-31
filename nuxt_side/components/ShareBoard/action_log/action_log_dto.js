// |---------------------|
// |---------------------|

import { Gs } from "@/components/models/gs.js"
import { TimeUtil } from "@/components/models/time_util.js"

export class ActionLogDto {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    Object.assign(this, params)
    this.unique_key = this.unique_key_generate()
    Object.freeze(this)
  }

  get dispay_time() {
    return TimeUtil.format_hhmmss(this.performed_at)
  }

  // private

  unique_key_generate() {
    const str = [
      this.label,
      this.from_connection_id,
      this.performed_at,
    ].join("/")
    return Gs.str_to_md5(str)
  }
}
