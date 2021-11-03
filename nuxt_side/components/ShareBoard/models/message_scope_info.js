import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MessageScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "is_ms_out",  name: "観戦者宛", },
      { key: "is_ms_all",       name: "全体",     },
    ]
  }
}
