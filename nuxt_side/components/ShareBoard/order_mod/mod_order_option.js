import { ChangePerInfo       } from "@/components/models/change_per_info.js"
import { FoulModeInfo } from "@/components/models/foul_mode_info.js"
import { AutoResignInfo } from "@/components/models/auto_resign_info.js"

export const mod_order_option = {
  computed: {
    ChangePerInfo()         { return ChangePerInfo                                      },

    FoulModeInfo()   { return FoulModeInfo                                },
    foul_mode_info() { return FoulModeInfo.fetch(this.foul_mode_key)  },

    AutoResignInfo()   { return AutoResignInfo                                },
    auto_resign_info() { return AutoResignInfo.fetch(this.auto_resign_key)  },
  },
}
