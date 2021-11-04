import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MessageScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_ms_all",  name: "全体",     label: "送信", icon: "play", type: "is-primary", class: "", title_icon: null, },
      { key: "is_ms_out",  name: "観戦者宛", label: "観戦", icon: "play", type: "is-success", class: "", title_icon: "🤫", },
    ]
  }
}
