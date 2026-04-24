import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkSwitchVisibilityInfo extends ApplicationMemoryRecord {
  static field_label = "自分の対局中に思考印の切り替えアイコンを表示"
  static field_message = ""

  static get define() {
    return [
      { key: "tmsv_hidden",  name: "しない", type: "is-primary", message: "", },
      { key: "tmsv_visible", name: "する",   type: "is-primary", message: "", },
    ]
  }
}
