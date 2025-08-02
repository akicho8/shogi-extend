import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class YomiageModeInfo extends ApplicationMemoryRecord {
  static field_label = "指し手の読み上げ"
  static field_message = null

  static get define() {
    return [
      { key: "is_yomiage_mode_on",  name: "する",   type: "is-primary", message: "対局時に「○○さん76歩」などと符号を読み上げる", },
      { key: "is_yomiage_mode_off", name: "しない", type: "is-warning", message: "静かにする (主に観戦者として実況したいとき用)", },
    ]
  }
}
