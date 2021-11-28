import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MessageScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_message_scope_public",  name: "全体",     label: "送信", icon: "play", type: "is-primary", class: "", title_icon: null, },
      { key: "is_message_scope_private",  name: "観戦者宛", label: "観戦", icon: "play", type: "is-success", class: "", title_icon: "🤫", },
    ]
  }
}
