import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"

export const app_storage = {
  mixins: [params_controller],
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
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
        user_name:            this.default_user_name,
        persistent_cc_params: this.default_persistent_cc_params,
      }
    },
  },
}
