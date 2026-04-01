import { GX } from "@/components/models/gx.js"
import { mod_board_click_warn } from "./mod_board_click_warn.js"
import { mod_function_disable } from "./mod_function_disable.js"

export const mod_audit = {
  mixins: [
    mod_board_click_warn,
    mod_function_disable,
  ],
}
