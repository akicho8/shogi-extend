import GeneralSettingModal from "./GeneralSettingModal.vue"

import { Foo1VolumeInfo       } from "../models/foo1_volume_info.js"
import { CtrlModeInfo         } from "../models/ctrl_mode_info.js"
import { QuickSyncInfo        } from "../models/quick_sync_info.js"
import { YomiageModeInfo      } from "../models/yomiage_mode_info.js"
import { NextTurnCallInfo      } from "../models/next_turn_call_info.js"
import { LiftCancelActionInfo } from "../models/lift_cancel_action_info.js"
import { LegalInfo            } from "../models/legal_info.js"
import { SettingCategoryInfo  } from "./setting_category_info.js"

export const mod_general_setting = {
  methods: {
    general_setting_modal_handle() {
      this.sidebar_p = false
      this.$sound.play_click()
      this.modal_card_open({
        component: GeneralSettingModal,
        props: { },
      })
    },
  },
  computed: {
    Foo1VolumeInfo()          { return Foo1VolumeInfo                                            },

    SettingCategoryInfo()     { return SettingCategoryInfo                                       },
    setting_category_info()   { return this.SettingCategoryInfo.fetch(this.setting_category_key) },

    CtrlModeInfo()            { return CtrlModeInfo                                              },
    ctrl_mode_info()          { return this.CtrlModeInfo.fetch(this.ctrl_mode_key)               },

    QuickSyncInfo()           { return QuickSyncInfo                                             },
    quick_sync_info()         { return this.QuickSyncInfo.fetch(this.quick_sync_key)             },

    YomiageModeInfo()         { return YomiageModeInfo                                           },
    yomiage_mode_info()       { return this.YomiageModeInfo.fetch(this.yomiage_mode_key)         },

    NextTurnCallInfo()         { return NextTurnCallInfo                                           },
    next_turn_call_info()       { return this.NextTurnCallInfo.fetch(this.next_turn_call_key)         },

    LiftCancelActionInfo()    { return LiftCancelActionInfo                                      },
    lift_cancel_action_info() { return this.LiftCancelActionInfo.fetch(this.lift_cancel_action)  },

    LegalInfo()               { return LegalInfo                                                 },
    legal_info()              { return this.LegalInfo.fetch(this.legal_key)                      },
    legal_strict_p()          { return this.legal_info.key === "strict"                          },
  },
}
