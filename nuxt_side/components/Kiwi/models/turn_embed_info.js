import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TurnEmbedInfo extends ApplicationMemoryRecord {
  static field_label = "手数表示"
  static field_message = ""

  static get define() {
    return [
      { key: "is_turn_embed_on",  name: "する",   type: "is-primary", message: null, },
      { key: "is_turn_embed_off", name: "しない", type: "is-primary", message: null, },
    ]
  }
}
