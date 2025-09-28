import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { ParamInfo } from "../../models/param_info.js"

export class SettingTabBase extends ApplicationMemoryRecord {
  get param_info() {
    return ParamInfo.fetch(this.key)
  }
}
