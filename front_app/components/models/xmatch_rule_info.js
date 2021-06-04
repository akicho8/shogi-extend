import MemoryRecord from "js-memory-record"
import { HandicapPresetInfo } from "@/components/models/handicap_preset_info.js"

export class XmatchRuleInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "rule_2vs2_0_10_60_0",          name: "2 vs 2",            rule_desc: "1手10秒 猶予60秒", members_count_max: 4, handicap_preset_key: "平手",       cc_params: { initial_main_min:  0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_3vs3_0_10_60_0",          name: "3 vs 3",            rule_desc: "1手10秒 猶予60秒", members_count_max: 6, handicap_preset_key: "平手",       cc_params: { initial_main_min:  0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_4vs4_0_10_60_0",          name: "4 vs 4",            rule_desc: "1手10秒 猶予60秒", members_count_max: 8, handicap_preset_key: "平手",       cc_params: { initial_main_min:  0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_1vs1_0_10_60_0",          name: "1 vs 1",            rule_desc: "1手10秒 猶予60秒", members_count_max: 2, handicap_preset_key: "平手",       cc_params: { initial_main_min:  0, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_1vs1_0_10_60_0_presetX1", name: "1 vs 1 (飛車vs角)", rule_desc: "1手10秒 猶予60秒", members_count_max: 2, handicap_preset_key: "平手",       cc_params: { initial_main_min:  0, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_self_0_10_60_0",          name: "自分 vs 自分",      rule_desc: "3分",              members_count_max: 1, handicap_preset_key: "平手",       cc_params: { initial_main_min:  3, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_self_0_10_60_0_preset00", name: "*☗視点",           rule_desc: "30分",             members_count_max: 1, handicap_preset_key: "平手",       cc_params: { initial_main_min: 30, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development"],                          },
      { key: "rule_self_0_10_60_0_preset19", name: "*☖視点",           rule_desc: "30分",             members_count_max: 1, handicap_preset_key: "十九枚落ち", cc_params: { initial_main_min: 30, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development"],                          },
    ]
  }

  get handicap_preset_info() {
    return HandicapPresetInfo.fetch(this.handicap_preset_key)
  }
}
