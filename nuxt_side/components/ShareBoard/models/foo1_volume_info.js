import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class Foo1VolumeInfo extends ApplicationMemoryRecord {
  static field_label = "読み上げ音量"
  static field_message = ""
  static input_type = "slider"
  static min = 1
  static max = 10
  static get define() {
    return [
    ]
  }
}
