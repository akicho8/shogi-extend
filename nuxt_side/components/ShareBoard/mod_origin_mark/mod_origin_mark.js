import { mod_origin_mark_support } from "./mod_origin_mark_support.js"
import { mod_origin_mark_restore } from "./mod_origin_mark_restore.js"
import { mod_origin_mark_action } from "./mod_origin_mark_action.js"

export const mod_origin_mark = {
  mixins: [
    mod_origin_mark_support,
    mod_origin_mark_restore,
    mod_origin_mark_action,
  ],
}
