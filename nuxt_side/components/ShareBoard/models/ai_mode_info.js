import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class AiModeInfo extends ApplicationMemoryRecord {
  static field_label = "ChatGPT"
  static field_message = ""

  static get define() {
    return [
      { key: "ai_mode_on",  name: "しゃべる", type: "is-primary", message: "あなたの発言に反応する場合がある", },
      { key: "ai_mode_off", name: "だまる",   type: "is-primary", message: "あなたの発言を無視する",           },
    ]
  }
}
