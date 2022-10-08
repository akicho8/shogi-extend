import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TegotoInfo extends ApplicationMemoryRecord {
  static field_label = "N手毎交代"
  static message = null
  static input_type = "numberinput"
  static min = 1
  static max = 10
  static hint_messages = [
    "N回指したら次の仲間に交代します",
  ]
  static get define() {
    return [
    ]
  }
}
