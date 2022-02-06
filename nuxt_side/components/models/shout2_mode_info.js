import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class Shout2ModeInfo extends ApplicationMemoryRecord {
  static field_label = "二歩制限"
  static message = null

  static get define() {
    return [
      { key: "is_shout2_mode_off", name: "なし", message: "二歩が打てる",   },
      { key: "is_shout2_mode_on",  name: "あり", message: "二歩は打てない", },
    ]
  }
}
