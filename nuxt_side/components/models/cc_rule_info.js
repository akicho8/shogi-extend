import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import _ from "lodash"

export class CcRuleInfo extends ApplicationMemoryRecord {
  // 初期値
  // 2要素配列にすると個別設定状態になる
  static default_cc_params_one = { initial_main_min: 0, initial_read_sec: 30, initial_extra_min: 1, every_plus: 0, }
  static default_cc_params = [this.default_cc_params_one]

  static cc_params_keys = [
    "initial_main_min",  // 持ち時間(分)
    "initial_read_sec",  // 秒読み
    "initial_extra_min", // 考慮時間(分)
    "every_plus",        // 1手毎加算
  ]

  static get define() {
    return [
      { name: "ウォーズ 10分", cc_params_one: { initial_main_min: 10, initial_read_sec:  0, initial_extra_min:  0, every_plus: 0, }, },
      { name: "ウォーズ 10秒", cc_params_one: { initial_main_min:  0, initial_read_sec: 10, initial_extra_min:  0, every_plus: 0, }, },
      { name: "24 早指",       cc_params_one: { initial_main_min:  1, initial_read_sec: 30, initial_extra_min:  0, every_plus: 0, }, },
      { name: "24 早指2",      cc_params_one: { initial_main_min:  0, initial_read_sec: 30, initial_extra_min:  1, every_plus: 0, }, },
      { name: "24 15分",       cc_params_one: { initial_main_min: 15, initial_read_sec: 60, initial_extra_min:  0, every_plus: 0, }, },
      { name: "ABEMA フィッシャー",  cc_params_one: { initial_main_min:  5, initial_read_sec:  0, initial_extra_min:  0, every_plus: 5, }, },
      // { name: "ウォーズ 3分",     cc_params_one: { initial_main_min:  3, initial_read_sec:  0, initial_extra_min: 0, every_plus: 0, }, },
      // { name: "将棋クエスト 5分", cc_params_one: { initial_main_min:  5, initial_read_sec:  0, initial_extra_min: 0, every_plus: 0, }, },
      // { name: "将棋クエスト 2分", cc_params_one: { initial_main_min:  2, initial_read_sec:  0, initial_extra_min: 0, every_plus: 0, }, },
      // { name: "24 長考",          cc_params_one: { initial_main_min: 30, initial_read_sec: 60, initial_extra_min: 0, every_plus: 0, }, },
    ]
  }

  get cc_params() {
    return _.cloneDeep([this.cc_params_one])
  }
}
