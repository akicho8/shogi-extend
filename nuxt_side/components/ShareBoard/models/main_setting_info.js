import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { ParamInfo } from './param_info.js'

export class MainSettingInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "sp_move_cancel",       },
      { key: "ctrl_mode_key",        },
      { key: "yomiage_mode_key",     },
      { key: "sp_internal_rule_key", },
      { key: "debug_mode_key",       },
    ]
  }
  
  get model() {
    return ParamInfo.fetch(this.key).relation
  }
}
