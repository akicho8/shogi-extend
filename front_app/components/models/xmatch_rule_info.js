import MemoryRecord from "js-memory-record"
import { HandicapPresetInfo } from "@/components/models/handicap_preset_info.js"

export class XmatchRuleInfo extends MemoryRecord {
  static get define() {
    return [
      // app/models/xmatch_rule_info.rb
      { key: "rule_1vs1_10_15_00_0",         members_count_max: 2, name: "10分",       rule_desc: "10分 読15",     handicap_preset_key: "平手",       cc_params: { initial_main_min: 10, initial_read_sec: 15, initial_extra_sec: 0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_1vs1_03_10_00_0",         members_count_max: 2, name: "3分",        rule_desc: "3分 読10",      handicap_preset_key: "平手",       cc_params: { initial_main_min:  3, initial_read_sec: 10, initial_extra_sec: 0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_1vs1_00_10_60_0",         members_count_max: 2, name: "10秒",       rule_desc: "0分 読10 猶60", handicap_preset_key: "平手",       cc_params: { initial_main_min:  0, initial_read_sec: 10, initial_extra_sec: 60, every_plus: 0, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_1vs1_05_00_00_5",         members_count_max: 2, name: "1 vs 1",       rule_desc: "ﾌｨｯｼｬｰ5+10",      handicap_preset_key: "平手",       cc_params: { initial_main_min:  5, initial_read_sec: 0, initial_extra_sec: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_2vs2_05_00_00_5",         members_count_max: 4, name: "2 vs 2",       rule_desc: "ﾌｨｯｼｬｰ5+10",      handicap_preset_key: "平手",       cc_params: { initial_main_min:  5, initial_read_sec: 0, initial_extra_sec: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_3vs3_05_00_00_5",         members_count_max: 6, name: "3 vs 3",       rule_desc: "ﾌｨｯｼｬｰ5+10",      handicap_preset_key: "平手",       cc_params: { initial_main_min:  5, initial_read_sec: 0, initial_extra_sec: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_4vs4_05_00_00_5",         members_count_max: 8, name: "4 vs 4",       rule_desc: "ﾌｨｯｼｬｰ5+10",      handicap_preset_key: "平手",       cc_params: { initial_main_min:  5, initial_read_sec: 0, initial_extra_sec: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_self_05_00_00_5",         members_count_max: 1, name: "対自分",       rule_desc: "ﾌｨｯｼｬｰ5+10",      handicap_preset_key: "平手",       cc_params: { initial_main_min:  5, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_2vs2_05_00_00_5_pRvsB",   members_count_max: 4, name: "飛 vs 角",     rule_desc: "ﾌｨｯｼｬｰ5+10",      handicap_preset_key: "飛vs角",   cc_params: { initial_main_min:  5, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_1vs1_05_00_00_5_pRvsB",   members_count_max: 2, name: "飛1vs1角", rule_desc: "ﾌｨｯｼｬｰ5+10",          handicap_preset_key: "飛vs角",   cc_params: { initial_main_min:  5, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 10, }, stage_only: ["development"], },
      { key: "rule_self_0_30_00_0_preset00", members_count_max: 1, name: "*☗視点",   rule_desc: "30分",            handicap_preset_key: "平手",       cc_params: { initial_main_min: 30, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development"],                          },
      { key: "rule_self_0_30_00_0_preset19", members_count_max: 1, name: "*☖視点",   rule_desc: "30分",            handicap_preset_key: "十九枚落ち", cc_params: { initial_main_min: 30, initial_read_sec:  0, initial_extra_sec:  0, every_plus: 0, }, stage_only: ["development"],                          },
    ]
  }

  get handicap_preset_info() {
    return HandicapPresetInfo.fetch(this.handicap_preset_key)
  }
}
