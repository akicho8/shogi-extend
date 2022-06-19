import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class YomiageModeInfo extends ApplicationMemoryRecord {
  static field_label = "検討時の棋譜読み上げ"
  static field_message = "時計を設置していないときを検討時と想定している。検討に集中したいときは「しない」にしよう"

  static get define() {
    return [
      { key: "is_yomiage_mode_on",  name: "する",   type: "is-primary", message: null, },
      { key: "is_yomiage_mode_off", name: "しない", type: "is-primary", message: null, },
    ]
  }
}
