import { TegotoInfo       } from "@/components/models/tegoto_info.js"
import { FoulBehaviorInfo } from "@/components/models/foul_behavior_info.js"
import { ResignTimingInfo } from "@/components/models/resign_timing_info.js"

export const app_order_option = {
  computed: {
    TegotoInfo()         { return TegotoInfo                                      },

    FoulBehaviorInfo()   { return FoulBehaviorInfo                                },
    foul_behavior_info() { return FoulBehaviorInfo.fetch(this.foul_behavior_key)  },

    ResignTimingInfo()   { return ResignTimingInfo                                },
    resign_timing_info() { return ResignTimingInfo.fetch(this.resign_timing_key)  },
  },
}
