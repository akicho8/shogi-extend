import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RuleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "rule100t",  name: "☗100問TAP", viewpoint: "black", time_limit: 60*3.5, play_break_miss_count: 50, },
      { key: "rule100tw", name: "☖100問TAP", viewpoint: "white", time_limit: 60*3.5, play_break_miss_count: 50, },
    ]
  }
}
