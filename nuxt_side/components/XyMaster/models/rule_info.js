import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class RuleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "rule100t",  name: "☗100問TAP", o_count_max: 100, viewpoint: "black", input_mode: "is_input_mode_tap", time_limit: 60*3.5, break_miss_gteq: 50, },
      { key: "rule100tw", name: "☖100問TAP", o_count_max: 100, viewpoint: "white", input_mode: "is_input_mode_tap", time_limit: 60*3.5, break_miss_gteq: 50, },
      { key: "rule100",   name: "☗100問",    o_count_max: 100, viewpoint: "black", input_mode: "is_input_mode_kb",  time_limit: 60*3.5, break_miss_gteq: 50, },
      { key: "rule100w",  name: "☖100問",    o_count_max: 100, viewpoint: "white", input_mode: "is_input_mode_kb",  time_limit: 60*3.5, break_miss_gteq: 50, },
    ]
  }

  // 時間切れか？
  time_over_p(spent_sec) {
    return spent_sec >= this.time_limit
  }

  // ミスの許容を超えたか？
  too_many_miss_p(x_count) {
    return x_count >= this.break_miss_gteq
  }
}
