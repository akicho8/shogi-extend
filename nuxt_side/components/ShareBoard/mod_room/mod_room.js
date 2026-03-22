import { mod_gate_modal            } from "./mod_gate_modal.js"
import { mod_room_active_level     } from "./mod_room_active_level.js"
import { mod_room_board_setup      } from "./mod_room_board_setup.js"
import { mod_room_channel          } from "./mod_room_channel.js"
import { mod_room_entry_leave      } from "./mod_room_entry_leave.js"
import { mod_room_key_autocomplete } from "./mod_room_key_autocomplete.js"
import { mod_room_members          } from "./mod_room_members.js"
import { mod_room_recreate         } from "./mod_room_recreate.js"
import { mod_room_restore          } from "./mod_room_restore.js"
import { mod_room_url_copy         } from "./mod_room_url_copy.js"

export const mod_room = {
  mixins: [
    mod_gate_modal,
    mod_room_active_level,
    mod_room_board_setup,
    mod_room_channel,
    mod_room_entry_leave,
    mod_room_key_autocomplete,
    mod_room_members,
    mod_room_recreate,
    mod_room_restore,
    mod_room_url_copy,
  ],
}
