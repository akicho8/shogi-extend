import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MemberStageInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // 順不同
      { key: "status_active",    name: "元気",     emoji: "",    css_class: "status_good",   },
      { key: "status_leave",     name: "完全離脱", emoji: "💀",  css_class: "status_bad", },
      { key: "status_look_away",      name: "よそ見中", emoji: "🙈",  css_class: "status_bad", },
      { key: "status_disconnet", name: "反応なし", emoji: "😴",  css_class: "status_bad", },
    ]
  }
}
