import { ChangePerInfo       } from "@/components/models/change_per_info.js"
import { IllegalBehaviorInfo } from "@/components/models/illegal_behavior_info.js"
import { AutoResignInfo } from "@/components/models/auto_resign_info.js"

export const mod_order_option = {
  computed: {
    ChangePerInfo()         { return ChangePerInfo                                      },

    IllegalBehaviorInfo()   { return IllegalBehaviorInfo                                },
    illegal_behavior_info() { return IllegalBehaviorInfo.fetch(this.illegal_behavior_key)  },

    AutoResignInfo()   { return AutoResignInfo                                },
    auto_resign_info() { return AutoResignInfo.fetch(this.auto_resign_key)  },
  },
}
