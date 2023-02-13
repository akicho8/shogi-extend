import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class DebugModeInfo extends ApplicationMemoryRecord {
  static field_label = "デバッグモード"
  static field_message = ""

  static get define() {
    return [
      { key: false, name: "OFF", type: "is-primary", message: null, },
      { key: true,  name: "ON",  type: "is-danger",  message: null, },
    ]
  }
}
