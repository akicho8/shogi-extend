import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"

export const mod_storage = {
  mixins: [params_controller],
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    ls_storage_key() {
      return `share_board${this.AppConfig.STORAGE_KEY_SUFFIX}`
    },
  },
}
