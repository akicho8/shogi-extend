import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkSwitchVisibilityInfo extends ApplicationMemoryRecord {
  static field_label = "自分が対局中のときも思考印の切り替えアイコンを表示"
  static field_message = ""

  static get define() {
    return [
      { key: "tmsv_hidden",  name: "しない", type: "is-primary", message: "初心者向け (表示しなくても右クリックで思考印は書けるしショートカットキーでも切り替え可能)", },
      { key: "tmsv_visible", name: "する",   type: "is-primary", message: "玄人向け (スマホでは UI がないと思考印モードを切り替えることができない)", },
    ]
  }
}
