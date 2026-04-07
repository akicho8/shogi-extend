import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class OriginMarkSwitchVisibilityInfo extends ApplicationMemoryRecord {
  static field_label = "自分の対局中に移動元印の切り替えアイコンを表示"
  static field_message = ""

  static get define() {
    return [
      { key: "tmsv_hidden",  name: "しない", type: "is-primary", message: "スマホまたは初心者向け (PCであれば表示しなくても右クリックで移動元印は書けるしショートカットキーでも、切り替えることができる)", },
      { key: "tmsv_visible", name: "する",   type: "is-primary", message: "玄人向け (注意: スマホではアイコンがないと移動元印モードを有効にすることができない)", },
    ]
  }
}
