import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class ViewpointInfo extends ApplicationMemoryRecord {
  static field_label = "視点"
  static field_message = ""

  static get define() {
    return [
      { key: "black", name: "☗ 先手", type: "is-primary", message: null, },
      { key: "white", name: "☖ 後手", type: "is-primary", message: null, },
    ]
  }
}
