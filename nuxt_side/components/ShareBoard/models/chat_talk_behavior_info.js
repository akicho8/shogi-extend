import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ChatTalkBehaviorInfo extends ApplicationMemoryRecord {
  static field_label = "チャットの読み上げ"
  static field_message = ""

  static get define() {
    return [
      { key: "is_chat_talk_behavior_on",  name: "する",   type: "is-primary", message: "読み上げる", },
      { key: "is_chat_talk_behavior_off", name: "しない", type: "is-warning", message: "静かにする", },
    ]
  }
}
