import MainSettingModal from "./MainSettingModal.vue"

import { CtrlModeInfo       } from "./models/ctrl_mode_info.js"
import { QuickSyncInfo      } from "./models/quick_sync_info.js"
import { YomiageModeInfo    } from "./models/yomiage_mode_info.js"
import { SpMoveCancelInfo   } from "./models/sp_move_cancel_info.js"
import { SpInternalRuleInfo } from "./models/sp_internal_rule_info.js"
import { DebugModeInfo      } from "./models/debug_mode_info.js"

export const app_main_setting = {
  methods: {
    // for autoexec
    is_debug_mode_on() { this.debug_mode_key = "is_debug_mode_on" },

    general_setting_modal_handle() {
      this.sidebar_p = false
      this.sound_play_click()
      this.modal_card_open({
        component: MainSettingModal,
        props: { base: this.base },
      })
    },
  },
  computed: {
    CtrlModeInfo()              { return CtrlModeInfo                                                 },
    ctrl_mode_info()            { return this.CtrlModeInfo.fetch(this.ctrl_mode_key)                  },

    QuickSyncInfo()             { return QuickSyncInfo                                                },
    quick_sync_info()           { return this.QuickSyncInfo.fetch(this.quick_sync_key)                },

    YomiageModeInfo()           { return YomiageModeInfo                                              },
    yomiage_mode_info()         { return this.YomiageModeInfo.fetch(this.yomiage_mode_key)            },

    SpMoveCancelInfo()          { return SpMoveCancelInfo                                             },
    sp_move_cancel_info()       { return this.SpMoveCancelInfo.fetch(this.sp_move_cancel_key)         },

    SpInternalRuleInfo()        { return SpInternalRuleInfo                                           },
    sp_internal_rule_info()     { return this.SpInternalRuleInfo.fetch(this.sp_internal_rule_key)     },
    sp_internal_rule_strict_p() { return this.sp_internal_rule_info.key === "is_internal_rule_strict" },

    DebugModeInfo()             { return DebugModeInfo                                                },
    debug_mode_info()           { return this.DebugModeInfo.fetch(this.debug_mode_key)                },
    debug_mode_p()              { return this.debug_mode_info.key === "is_debug_mode_on"              },
  },
}
