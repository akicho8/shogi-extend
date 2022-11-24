import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { ParamInfo } from "./param_info.js"

export class MainSettingInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "sp_move_cancel_key",   },
      { key: "ctrl_mode_key",        },
      { key: "quick_sync_key",       },
      { key: "yomiage_mode_key",     },
      { key: "legal_key", },
      { key: "foul_behavior_key",       },
      // { key: "toryo_timing_key",       },
      { key: "debug_mode_key",       },
    ]
  }

  get param_info() {
    return ParamInfo.fetch(this.key)
  }
}
