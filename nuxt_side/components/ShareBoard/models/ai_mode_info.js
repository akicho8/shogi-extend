import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AiModeInfo extends ApplicationMemoryRecord {
  static field_label = "ChatGPT"
  static field_message = ""

  static get define() {
    return [
      { key: "ai_mode_on",  name: "しゃべる", type: "is-primary", message: null, },
      { key: "ai_mode_off", name: "黙る",     type: "is-primary", message: null, },
    ]
  }
}
