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
    ls_storage_key() {
      return "swars/battles/index"
    },
    // ls_default() {
    //   return {
    //     ...this.pc_ls_default,
    //     // scene_key:  this.config.scene_key,
    //     // remember_vs_user_keys: [],
    //   }
    // },
  },
}
