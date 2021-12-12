import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ComplementUserKeysPrependInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "user_key", name: "ウォーズIDのみ", str_fetch: e => e.config.current_swars_user_key, },
      { key: "query",    name: "クエリ全体",     str_fetch: e => e.query,                         },
    ]
  }
}
