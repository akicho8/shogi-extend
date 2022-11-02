const STORAGE_VERSION = 0

import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"

export const app_storage = {
  mixins: [params_controller],
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    ls_storage_key() {
      if (STORAGE_VERSION >= 1) {
        return `share_board_v${STORAGE_VERSION}`
      } else {
        return `share_board`
      }
    },
  },
}
