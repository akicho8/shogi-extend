import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class PentagonAppearanceInfo extends ApplicationMemoryRecord {
  static field_label = "☗☖の位置にアバターを表示"
  static field_message = ""

  static get define() {
    return [
      { key: "pentagon_appearance_as_avatar", name: "する",   type: "is-primary", message: "", },
      { key: "pentagon_appearance_as_is",     name: "しない", type: "is-warning", message: "", },
    ]
  }
}
