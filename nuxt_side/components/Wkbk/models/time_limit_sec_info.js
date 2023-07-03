import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TimeLimitSecInfo extends ApplicationMemoryRecord {
  static field_label = "制限秒数"
  static field_message = ""
  static input_type = "numberinput"
  static min = 0
  static step = 1
  static max = 60 * 60

  static get define() {
    return [
    ]
  }
}
