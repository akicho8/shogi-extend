import { mod_think_mark_support } from "./mod_think_mark_support.js"
import { mod_think_mark_restore } from "./mod_think_mark_restore.js"
import { mod_think_mark_group_reject_action } from "./mod_think_mark_group_reject_action.js"
import { mod_think_mark_clear_all_action } from "./mod_think_mark_clear_all_action.js"
import { mod_think_mark_action } from "./mod_think_mark_action.js"

export const mod_think_mark = {
  mixins: [
    mod_think_mark_support,
    mod_think_mark_restore,
    mod_think_mark_group_reject_action,
    mod_think_mark_clear_all_action,
    mod_think_mark_action,
  ],
}
