import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class QuickSyncInfo extends ApplicationMemoryRecord {
  static field_label = "盤面同期のタイミング"
  static field_message = ""

  static get define() {
    return [
      { key: "is_quick_sync_on",  name: "自動", type: "is-primary", sidebar_function_show: false, message: "とにかく自動的に同期する(推奨)",     },
      { key: "is_quick_sync_off", name: "手動", type: "is-danger",  sidebar_function_show: true,  message: "なるべく手動で同期する(以前の難しい方法)", },
    ]
  }
}
