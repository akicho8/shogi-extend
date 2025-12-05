import { ChangePerInfo  } from "@/components/models/change_per_info.js"
import { FoulModeInfo   } from "@/components/models/foul_mode_info.js"

export const mod_order_option = {
  computed: {
    ChangePerInfo()    { return ChangePerInfo                              },

    FoulModeInfo()     { return FoulModeInfo                               },
    foul_mode_info()   { return FoulModeInfo.fetch(this.foul_mode_key)     },
  },
}
