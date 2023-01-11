import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class YomiageModeInfo extends ApplicationMemoryRecord {
  static field_label = "手番や指し手の読み上げ"
  static field_message = null

  static get define() {
    return [
      { key: "is_yomiage_mode_on",  name: "する",   type: "is-primary", message: "よくしゃべる", },
      { key: "is_yomiage_mode_off", name: "しない", type: "is-primary", message: "寡黙になる",   },
    ]
  }
}
