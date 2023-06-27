import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { ParamInfo } from "../models/param_info.js"

export class GeneralSettingInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "foo1_volume",          },
      { key: "yomiage_mode_key",     },
      { key: "lift_cancel_action",   },
      { key: "ctrl_mode_key",        },
      { key: "quick_sync_key",       },
      { key: "legal_key",            },
      { key: "illegal_behavior_key", },
      // { key: "auto_resign_key",   },
      { key: "debug_mode_key",       },
    ]
  }

  get param_info() {
    return ParamInfo.fetch(this.key)
  }
}
