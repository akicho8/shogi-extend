import { TegotoInfo       } from "@/components/models/tegoto_info.js"
import { IllegalBehaviorInfo } from "@/components/models/illegal_behavior_info.js"
import { ResignTimingInfo } from "@/components/models/resign_timing_info.js"

export const app_order_option = {
  computed: {
    TegotoInfo()         { return TegotoInfo                                      },

    IllegalBehaviorInfo()   { return IllegalBehaviorInfo                                },
    illegal_behavior_info() { return IllegalBehaviorInfo.fetch(this.illegal_behavior_key)  },

    ResignTimingInfo()   { return ResignTimingInfo                                },
    resign_timing_info() { return ResignTimingInfo.fetch(this.resign_timing_key)  },
  },
}
