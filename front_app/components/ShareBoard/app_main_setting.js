import MainSettingModal from "./MainSettingModal.vue"
import { SpInternalRuleInfo } from "../../components/models/sp_internal_rule_info.js"
import { DebugInfo } from "../../components/models/debug_info.js"

export const app_main_setting = {
  methods: {
    // for autoexec
    is_debug_on() { this.debug_key = "is_debug_on" },

    general_setting_modal_handle() {
      this.sidebar_p = false
      this.sound_play("click")

      this.$buefy.modal.open({
        customClass: "MainSettingModal",
        component: MainSettingModal,
        parent: this,
        trapFocus: true,
        hasModalCard: true,
        animation: "",
        canCancel: true,
        onCancel: () => {
          this.sound_play("click")
        },
        props: {
          base: this.base,
        },
      })
    },
  },
  computed: {
    SpInternalRuleInfo()    { return SpInternalRuleInfo                                       },
    sp_internal_rule_info() { return this.SpInternalRuleInfo.fetch(this.sp_internal_rule_key) },
    strict_p()              { return this.sp_internal_rule_info.key === "is_internal_rule_strict"  },

    DebugInfo()             { return DebugInfo                                   },
    debug_info()            { return this.DebugInfo.fetch(this.debug_key)        },
    debug_mode_p()          { return this.debug_info.key === "is_debug_on"  },
  },
}
