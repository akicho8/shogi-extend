import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class DebugModeInfo extends ApplicationMemoryRecord {
  static field_label = "デバッグ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_debug_mode_off", name: "OFF", type: "is-primary", message: null, },
      { key: "is_debug_mode_on",  name: "ON",  type: "is-danger",  message: null, },
    ]
  }
}
