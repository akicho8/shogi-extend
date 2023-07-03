import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TimeLimitFuncInfo extends ApplicationMemoryRecord {
  static field_label = "時間制限"

  static get define() {
    return [
      { key: "time_limit_func_off", name: "しない", },
      { key: "time_limit_func_on",  name: "する",   },
    ]
  }
}
