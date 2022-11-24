import { TegotoInfo       } from "@/components/models/tegoto_info.js"
import { FoulBehaviorInfo } from "@/components/models/foul_behavior_info.js"
import { ToryoTimingInfo } from "@/components/models/toryo_timing_info.js"

export const app_order_option = {
  computed: {
    TegotoInfo()         { return TegotoInfo                                      },

    FoulBehaviorInfo()   { return FoulBehaviorInfo                                },
    foul_behavior_info() { return FoulBehaviorInfo.fetch(this.foul_behavior_key)  },

    ToryoTimingInfo()   { return ToryoTimingInfo                                },
    toryo_timing_info() { return ToryoTimingInfo.fetch(this.toryo_timing_key)  },
  },
}
