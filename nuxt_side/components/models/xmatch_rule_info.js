import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { BoardPresetInfo } from "@/components/models/board_preset_info.js"
import _ from "lodash"

export class XmatchRuleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      // app/models/xmatch_rule_info.rb
      { key: "rule_1vs1_10_15_00_0",           members_count_max: 2, name: "10分",       rule_desc: "秒読み15秒", board_preset_key: "平手",           cc_params_one: { initial_main_min: 10, initial_read_sec: 15, initial_extra_min: 0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_1vs1_03_10_00_0",           members_count_max: 2, name: "3分",        rule_desc: "秒読み10秒", board_preset_key: "平手",           cc_params_one: { initial_main_min:  3, initial_read_sec: 10, initial_extra_min: 0, every_plus: 0, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_1vs1_00_10_60_0",           members_count_max: 2, name: "10秒",       rule_desc: "考慮時間60秒",   board_preset_key: "平手",           cc_params_one: { initial_main_min:  0, initial_read_sec: 10, initial_extra_min: 1, every_plus: 0, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_1vs1_05_00_00_5",           members_count_max: 2, name: "1 vs 1",     rule_desc: "5分+10秒",   board_preset_key: "平手",           cc_params_one: { initial_main_min:  5, initial_read_sec: 0, initial_extra_min: 0, every_plus: 10, }, stage_only: ["development", "staging"], },
      { key: "rule_2vs2_05_00_00_5",           members_count_max: 4, name: "2 vs 2",     rule_desc: "5分+10秒",   board_preset_key: "平手",           cc_params_one: { initial_main_min:  5, initial_read_sec: 0, initial_extra_min: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_3vs3_05_00_00_5",           members_count_max: 6, name: "3 vs 3",     rule_desc: "5分+10秒",   board_preset_key: "平手",           cc_params_one: { initial_main_min:  5, initial_read_sec: 0, initial_extra_min: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },
      { key: "rule_4vs4_05_00_00_5",           members_count_max: 8, name: "4 vs 4",     rule_desc: "5分+10秒",   board_preset_key: "平手",           cc_params_one: { initial_main_min:  5, initial_read_sec: 0, initial_extra_min: 0, every_plus: 10, }, stage_only: ["development", "staging", "production"], },

      { key: "rule_2vs2_05_00_00_5_pRvsB",     members_count_max: 4, name: "飛 vs 角",   rule_desc: "5分+10秒",   board_preset_key: "飛vs角",         cc_params_one: { initial_main_min:  5, initial_read_sec:  0, initial_extra_min:  0, every_plus: 10, }, stage_only: ["development", "staging"], },
      { key: "rule_self_05_00_00_5",           members_count_max: 1, name: "対自分",     rule_desc: "5分+10秒",   board_preset_key: "平手",           cc_params_one: { initial_main_min:  5, initial_read_sec:  0, initial_extra_min:  0, every_plus: 10, }, stage_only: ["development", "staging"], },

      { key: "rule_1vs1_05_00_00_5_pRvsB",     members_count_max: 2, name: "飛1vs1角",   rule_desc: "5分+10秒",   board_preset_key: "飛vs角",         cc_params_one: { initial_main_min:  5, initial_read_sec:  0, initial_extra_min:  0, every_plus: 10, }, stage_only: ["development"], },
      { key: "rule_self_0_30_00_0_preset00",   members_count_max: 1, name: "*☗視点",     rule_desc: "30分",       board_preset_key: "平手",           cc_params_one: { initial_main_min: 30, initial_read_sec:  0, initial_extra_min:  0, every_plus: 0, }, stage_only: ["development"],                          },
      { key: "rule_self_0_30_00_0_preset19",   members_count_max: 1, name: "*☖視点",     rule_desc: "30分",       board_preset_key: "十九枚落ち",     cc_params_one: { initial_main_min: 30, initial_read_sec:  0, initial_extra_min:  0, every_plus: 0, }, stage_only: ["development"],                          },
    ]
  }

  get board_preset_info() {
    return BoardPresetInfo.fetch(this.board_preset_key)
  }

  get cc_params() {
    return _.cloneDeep([this.cc_params_one])
  }
}
