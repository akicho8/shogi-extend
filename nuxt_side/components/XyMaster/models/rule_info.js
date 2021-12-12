import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RuleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "rule100t",  name: "☗100問TAP", o_count_max: 100, viewpoint: "black", input_mode: "is_input_mode_tap", time_limit: 60*3.5, play_break_miss_count: 50, },
      { key: "rule100tw", name: "☖100問TAP", o_count_max: 100, viewpoint: "white", input_mode: "is_input_mode_tap", time_limit: 60*3.5, play_break_miss_count: 50, },
      { key: "rule100",   name: "☗100問",    o_count_max: 100, viewpoint: "black", input_mode: "is_input_mode_kb",  time_limit: 60*3.5, play_break_miss_count: 50, },
      { key: "rule100w",  name: "☖100問",    o_count_max: 100, viewpoint: "white", input_mode: "is_input_mode_kb",  time_limit: 60*3.5, play_break_miss_count: 50, },
    ]
  }
}
