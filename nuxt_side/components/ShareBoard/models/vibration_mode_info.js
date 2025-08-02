import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class VibrationModeInfo extends ApplicationMemoryRecord {
  static field_label = "振動"
  static field_message = null

  static get define() {
    return [
      { key: "vibration_mode_on",  name: "する",   type: "is-primary", message: "手番が来たら振動する (Android のみ)",  },
      { key: "vibration_mode_off", name: "しない", type: "is-primary", message: "手番が来ても振動しない",               },
    ]
  }
}
