import { mod_think_mark_support } from "./mod_think_mark_support.js"
import { mod_think_mark_restore } from "./mod_think_mark_restore.js"
import { mod_think_mark_reject_action } from "./mod_think_mark_reject_action.js"
import { mod_think_mark_clear_action } from "./mod_think_mark_clear_action.js"
import { mod_think_mark_click_action } from "./mod_think_mark_click_action.js"

export const mod_think_mark = {
  mixins: [
    mod_think_mark_support,
    mod_think_mark_restore,
    mod_think_mark_reject_action,
    mod_think_mark_clear_action,
    mod_think_mark_click_action,
  ],
}
