import MainSettingModal from "./MainSettingModal.vue"
import { CtrlModeInfo       } from "../../components/models/ctrl_mode_info.js"
import { YomiageModeInfo    } from "../../components/models/yomiage_mode_info.js"
import { SpMoveCancelInfo   } from "../../components/models/sp_move_cancel_info.js"
import { SpInternalRuleInfo } from "../../components/models/sp_internal_rule_info.js"
import { DebugInfo          } from "../../components/models/debug_info.js"

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
    CtrlModeInfo()          { return CtrlModeInfo                                                 },
    ctrl_mode_info()        { return this.CtrlModeInfo.fetch(this.ctrl_mode_key)                  },

    YomiageModeInfo()       { return YomiageModeInfo                                              },
    yomiage_mode_info()     { return this.YomiageModeInfo.fetch(this.yomiage_mode_key)            },

    SpMoveCancelInfo()      { return SpMoveCancelInfo                                             },
    sp_move_cancel_info()   { return this.SpMoveCancelInfo.fetch(this.sp_move_cancel)             },

    SpInternalRuleInfo()    { return SpInternalRuleInfo                                           },
    sp_internal_rule_info() { return this.SpInternalRuleInfo.fetch(this.sp_internal_rule_key)     },
    strict_p()              { return this.sp_internal_rule_info.key === "is_internal_rule_strict" },

    DebugInfo()             { return DebugInfo                                                    },
    debug_info()            { return this.DebugInfo.fetch(this.debug_key)                         },
    debug_mode_p()          { return this.debug_info.key === "is_debug_on"                        },
  },
}
