import MemoryRecord from "js-memory-record"

export class SbxRuleInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "rule_self_0_10_60_0", name: "自分vs自分 1手10秒 猶予60秒", members_count_max: 1, preset_key: "平手", cc_params: { initial_main_min: 0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development"],                          },
      { key: "rule_1vs1_0_10_60_0", name: "1vs1 1手10秒 猶予60秒",       members_count_max: 2, preset_key: "平手", cc_params: { initial_main_min: 0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development"],                          },
      { key: "rule_2vs2_0_10_60_0", name: "2vs2 1手10秒 猶予60秒",       members_count_max: 4, preset_key: "平手", cc_params: { initial_main_min: 0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_4vs4_0_10_60_0", name: "4vs4 1手10秒 猶予60秒",       members_count_max: 8, preset_key: "平手", cc_params: { initial_main_min: 0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
    ]
  }
}
