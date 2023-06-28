import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class YomiageModeInfo extends ApplicationMemoryRecord {
  static field_label = "指し手の読み上げ"
  static field_message = "対局時、指した直後に符号を読み上げるかどうかの設定。読み上げた方が雰囲気が出るが、静かに対局したいときには無効にしよう"

  static get define() {
    return [
      { key: "is_yomiage_mode_on",  name: "する",   type: "is-primary", message: null, },
      { key: "is_yomiage_mode_off", name: "しない", type: "is-warning", message: null, },
    ]
  }
}
