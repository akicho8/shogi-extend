import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class VibrationModeInfo extends ApplicationMemoryRecord {
  static field_label = "振動"
  static field_message = "随所でスマホを振動させるか？ (Androidのみ)"

  static get define() {
    return [
      { key: "vibration_mode_on",  name: "あり", type: "is-primary", message: null, },
      { key: "vibration_mode_off", name: "なし", type: "is-primary", message: null, },
    ]
  }
}
