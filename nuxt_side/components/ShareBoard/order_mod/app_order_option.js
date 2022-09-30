import { MoveGuardInfo    } from "@/components/models/move_guard_info.js"
import { TegotoInfo       } from "@/components/models/tegoto_info.js"
import { FoulBehaviorInfo } from "@/components/models/foul_behavior_info.js"

export const app_order_option = {
  computed: {
    MoveGuardInfo()      { return MoveGuardInfo                                   },
    move_guard_info()    { return MoveGuardInfo.fetch(this.move_guard_key)        },

    TegotoInfo()         { return TegotoInfo                                      },

    FoulBehaviorInfo()   { return FoulBehaviorInfo                                },
    foul_behavior_info() { return FoulBehaviorInfo.fetch(this.foul_behavior_key)  },
  },
}
