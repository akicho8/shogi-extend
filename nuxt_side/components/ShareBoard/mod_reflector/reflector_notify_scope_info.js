import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ReflectorNotifyScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      {
        key: "rns_all",
        name: "全員",
        condition_fn: (context, params) => true,
      },
      {
        key: "rns_except_me",
        name: "自分を除く",
        condition_fn: (context, params) => !context.received_from_self(params),
      },
    ]
  }
}
