import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"

export const mod_storage = {
  mixins: [
    params_controller,
  ],
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin
    ls_storage_key() {
      return "xy_master_lite"
    },
    ls_default() {
      return {
      }
    },
  },
}
