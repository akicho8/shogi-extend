import { mod_member_list       } from "./mod_member_list.js"
import { mod_member_info_modal } from "./mod_member_info_modal.js"
import { mod_ping              } from "./mod_ping.js"
import { mod_net_level         } from "./mod_net_level.js"

export const mod_member_profile = {
  mixins: [
    mod_member_list,
    mod_member_info_modal,
    mod_ping,
    mod_net_level,
  ],
}
