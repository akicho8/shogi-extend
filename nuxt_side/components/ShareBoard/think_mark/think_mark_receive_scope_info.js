import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ThinkMarkReceiveScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "tmrs_watcher_only",          name: "観戦者のみ",     },
      { key: "tmrs_watcher_with_opponent", name: "観戦者と対局者", },
      { key: "tmrs_everyone",              name: "つつぬけ",       },
    ]
  }
}
