import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TacticInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "attack",    name: "戦法", },
      { key: "defense",   name: "囲い", },
      { key: "technique", name: "手筋", },
      { key: "note",      name: "備考", },
    ]
  }

  get tag_list_name() {
    return `${this.key}_tag_list`
  }
}
