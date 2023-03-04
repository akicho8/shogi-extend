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
  mounted() {
    if (this.development_p) {
    } else {
      // production では pointerdown を強制する
      this.tap_detect_key = "pointerdown"
    }
  },
  computed: {
    ParamInfo() { return ParamInfo },

    //////////////////////////////////////////////////////////////////////////////// for ls_support_mixin
    ls_storage_key() {
      return "new_xy_master2"
    },
    ls_default() {
      return {
        ...this.pc_ls_default,
        rule_key:        this.default_rule_key,
        chart_rule_key:  this.default_rule_key,
        scope_key:       "scope_today",
        chart_scope_key: "chart_scope_recently",
        entry_name:      this.g_current_user_name || "",
        current_pages:   {},
      }
    },
  },
}
