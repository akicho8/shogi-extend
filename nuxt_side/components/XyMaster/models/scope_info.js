import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "scope_today",      name: "本日", date_show_p: false, },
      { key: "scope_yesterday",  name: "昨日", date_show_p: false, },
      { key: "scope_month",      name: "今月", date_show_p: false, },
      { key: "scope_prev_month", name: "先月", date_show_p: false, },
      { key: "scope_all",        name: "全体", date_show_p: true,  },
    ]
  }
}
