import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChangePerInfo extends ApplicationMemoryRecord {
  static field_label = "N手毎交代"
  static field_message = null
  static input_type = "numberinput"
  static min = 1
  static max = 100
  static hint_messages = [
    "N回指したら交代します",
  ]
  static get define() {
    return [
    ]
  }
}
