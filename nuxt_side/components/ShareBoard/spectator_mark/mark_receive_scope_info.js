import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class MarkReceiveScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "watcher_only",          name: "観戦者のみ",     },
      { key: "watcher_with_opponent", name: "観戦者と対局者", },
    ]
  }
}
