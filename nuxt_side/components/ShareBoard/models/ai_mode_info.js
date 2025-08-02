import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AiModeInfo extends ApplicationMemoryRecord {
  static field_label = "ChatGPT"
  static field_message = ""

  static get define() {
    return [
      { key: "ai_mode_on",  name: "しゃべる", type: "is-primary", message: "ときどきチャットに反応したりする", },
      { key: "ai_mode_off", name: "だまる",   type: "is-primary", message: "静かにする",                       },
    ]
  }
}
