// |---------------------|
// |---------------------|

import { GX } from "@/components/models/gx.js"
import { TimeHelper } from "@/components/models/time_helper.js"
import { RoleGroup } from "../mod_role/role_group.js"

export class XhistoryRecord {
  static create(params) {
    return new this(params)
  }

  constructor(params) {
    // params = {...params}
    // delete params.role_group

    Object.assign(this, params)

    this.unique_key = this.unique_key_generate()

    Object.freeze(this)
  }

  get display_time() {
    return TimeHelper.format_hhmmss(this.performed_at)
  }

  get modal_title_or_default() {
    return this.modal_title ?? "局面"
  }

  get role_group() {
    return RoleGroup.create(this.role_group_attributes)
  }

  // get sfen_and_turn() {
  //   return { sfen: this.sfen, turn: this.turn }
  // }

  // private

  unique_key_generate() {
    const str = [
      this.label,
      this.from_connection_id,
      this.performed_at,
    ].join("/")
    return GX.str_to_md5(str)
  }
}
