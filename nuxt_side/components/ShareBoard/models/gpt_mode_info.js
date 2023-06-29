import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class GptModeInfo extends ApplicationMemoryRecord {
  static field_label = "ChatGPTのおしゃべり"
  static field_message = "いろんなタイミングで口を挟んでくる"

  static get define() {
    return [
      { key: "gpt_mode_on",  name: "有効", type: "is-primary", message: null, },
      { key: "gpt_mode_off", name: "無効", type: "is-primary", message: null, },
    ]
  }
}
