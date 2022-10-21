import MainSettingModal from "./MainSettingModal.vue"

import { CtrlModeInfo       } from "./models/ctrl_mode_info.js"
import { QuickSyncInfo      } from "./models/quick_sync_info.js"
import { YomiageModeInfo    } from "./models/yomiage_mode_info.js"
import { SpMoveCancelInfo   } from "./models/sp_move_cancel_info.js"
import { LegalInfo } from "./models/legal_info.js"

export const app_main_setting = {
  methods: {
    general_setting_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
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

    LegalInfo()        { return LegalInfo                                           },
    legal_info()     { return this.LegalInfo.fetch(this.legal_key)     },
    legal_strict_p() { return this.legal_info.key === "strict" },
  },
}
