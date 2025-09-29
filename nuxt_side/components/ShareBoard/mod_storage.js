import { params_controller } from "@/components/params_controller.js"
import { ParamInfo } from "./models/param_info.js"
import { MyLocalStorage } from "@/components/models/my_local_storage.js"

export const mod_storage = {
  mixins: [params_controller],
  mounted() {
    MyLocalStorage.remove(this.ls_storage_key_old) // 一つ前のバージョンを消す
  },
  data() {
    return {
      ...ParamInfo.null_value_data_hash,
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    ls_storage_key() {
      return `share_board${this.AppConfig.STORAGE_KEY_SUFFIX_NEW}`
    },

    ls_storage_key_old() {
      return `share_board${this.AppConfig.STORAGE_KEY_SUFFIX_OLD}`
    },
  },
}
