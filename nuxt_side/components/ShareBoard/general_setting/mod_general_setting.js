import { general_setting_modal } from "./general_setting_modal.js"

import GeneralSettingModal from "./GeneralSettingModal.vue"

import { ClockVolumeInfo       } from "../models/clock_volume_info.js"
import { MoveVolumeInfo       } from "../models/move_volume_info.js"
import { TalkVolumeInfo       } from "../models/talk_volume_info.js"
import { CtrlModeInfo         } from "../models/ctrl_mode_info.js"
import { QuickSyncInfo        } from "../models/quick_sync_info.js"
import { YomiageModeInfo      } from "../models/yomiage_mode_info.js"
import { AiModeInfo          } from "../models/ai_mode_info.js"
import { ByoyomiModeInfo      } from "../models/byoyomi_mode_info.js"
import { VibrationModeInfo      } from "../models/vibration_mode_info.js"
import { NextTurnCallInfo      } from "../models/next_turn_call_info.js"
import { LiftCancelActionInfo } from "../models/lift_cancel_action_info.js"
import { LegalInfo            } from "../models/legal_info.js"
import { SettingCategoryInfo  } from "./setting_category_info.js"

export const mod_general_setting = {
  mixins: [general_setting_modal],
  beforeDestroy() {
    this.talk_volume_reset()
  },
  watch: {
    talk_volume(v) { this.g_talk_volume = v },
  },
  computed: {
    ClockVolumeInfo()         { return ClockVolumeInfo                                           },

    MoveVolumeInfo()        { return MoveVolumeInfo                                          },

    TalkVolumeInfo()          { return TalkVolumeInfo                                            },

    SettingCategoryInfo()     { return SettingCategoryInfo                                       },
    setting_category_info()   { return this.SettingCategoryInfo.fetch(this.setting_category_key) },

    CtrlModeInfo()            { return CtrlModeInfo                                              },
    ctrl_mode_info()          { return this.CtrlModeInfo.fetch(this.ctrl_mode_key)               },

    QuickSyncInfo()           { return QuickSyncInfo                                             },
    quick_sync_info()         { return this.QuickSyncInfo.fetch(this.quick_sync_key)             },

    YomiageModeInfo()         { return YomiageModeInfo                                           },
    yomiage_mode_info()       { return this.YomiageModeInfo.fetch(this.yomiage_mode_key)         },

    AiModeInfo()              { return AiModeInfo                                                },
    ai_mode_info()            { return this.AiModeInfo.fetch(this.ai_mode_key)                   },

    ByoyomiModeInfo()         { return ByoyomiModeInfo                                           },
    byoyomi_mode_info()       { return this.ByoyomiModeInfo.fetch(this.byoyomi_mode_key)         },

    VibrationModeInfo()       { return VibrationModeInfo                                         },
    vibration_mode_info()     { return this.VibrationModeInfo.fetch(this.vibration_mode_key)     },

    NextTurnCallInfo()        { return NextTurnCallInfo                                          },
    next_turn_call_info()     { return this.NextTurnCallInfo.fetch(this.next_turn_call_key)      },

    LiftCancelActionInfo()    { return LiftCancelActionInfo                                      },
    lift_cancel_action_info() { return this.LiftCancelActionInfo.fetch(this.lift_cancel_action)  },

    LegalInfo()               { return LegalInfo                                                 },
    legal_info()              { return this.LegalInfo.fetch(this.legal_key)                      },
    legal_strict_p()          { return this.legal_info.key === "strict"                          },
  },
}
