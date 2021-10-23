import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class IndexScopeInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "everyone", name: "全体",   },
      { key: "public",   name: "公開",   },
      { key: "private",  name: "非公開", },
    ]
  }
}
