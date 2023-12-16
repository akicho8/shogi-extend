import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MessageScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "ms_public",  name: "全体",     label: "送信", icon: "play", type: "is-primary", class: "", title_emoji: "",   toast_type: "is-white",   message_class: null,              },
      { key: "ms_private", name: "観戦者宛", label: "観戦", icon: "play", type: "is-success", class: "", title_emoji: "🙊", toast_type: "is-success", message_class: "has-text-success" },
    ]
  }
}
