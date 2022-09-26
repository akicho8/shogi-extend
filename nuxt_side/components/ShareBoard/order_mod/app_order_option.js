import { MoveGuardInfo    } from "@/components/models/move_guard_info.js"
import { ShoutModeInfo    } from "@/components/models/shout_mode_info.js"
import { TegotoInfo       } from "@/components/models/tegoto_info.js"
import { FoulBehaviorInfo } from "@/components/models/foul_behavior_info.js"

export const app_order_option = {
  computed: {
    MoveGuardInfo()      { return MoveGuardInfo                                   },
    move_guard_info()    { return MoveGuardInfo.fetch(this.move_guard_key)        },

    ShoutModeInfo()      { return ShoutModeInfo                                   },
    shout_mode_info()    { return ShoutModeInfo.fetch(this.shout_mode_key)        },
    is_shout_mode_on()   { return this.shout_mode_info.key === "is_shout_mode_on" },

    TegotoInfo()         { return TegotoInfo                                      },

    FoulBehaviorInfo()   { return FoulBehaviorInfo                                },
    foul_behavior_info() { return FoulBehaviorInfo.fetch(this.foul_behavior_key)  },
  },
}
