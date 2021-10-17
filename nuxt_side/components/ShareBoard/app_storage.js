import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./param_info.js"

export const app_storage = {
  mixins: [params_controller],
  data() {
    return {
      share_board_column_width: null,
      persistent_cc_params: null,
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    ls_storage_key() {
      return "share_board"
    },

    ls_default() {
      return {
        ...this.pc_ls_default,
        // share_board_column_width: 80,
        user_name: this.default_user_name,
        persistent_cc_params: this.default_persistent_cc_params,
        sp_move_cancel: this.DEFAULT_VARS.sp_move_cancel,
      }
    },
  },
}
