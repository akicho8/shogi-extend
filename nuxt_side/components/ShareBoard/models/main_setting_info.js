import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MainSettingInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "sp_move_cancel_key",   },
      { key: "ctrl_mode_key",        },
      { key: "quick_sync_key",       },
      { key: "yomiage_mode_key",     },
      { key: "sp_internal_rule_key", },
      { key: "debug_mode_key",       },
    ]
  }
}
