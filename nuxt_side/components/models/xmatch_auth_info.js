import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class XmatchAuthInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "login_required",        name: "ログイン必須", message: null, },
      { key: "handle_name_required",  name: "ログイン不要", message: null, },
    ]
  }
}
