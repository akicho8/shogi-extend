import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class CcRuleInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { name: "将棋ウォーズ 10分",           cc_params: { initial_main_min: 10, initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0, }, },
      // { name: "将棋ウォーズ 3分",            cc_params: { initial_main_min: 3,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0, }, },
      { name: "将棋ウォーズ 10秒",           cc_params: { initial_main_min: 0,  initial_read_sec:10, initial_extra_sec: 0,  every_plus:0, }, },
      // { name: "将棋クエスト 5分",            cc_params: { initial_main_min: 5,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0, }, },
      // { name: "将棋クエスト 2分",            cc_params: { initial_main_min: 2,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:0, }, },
      { name: "将棋倶楽部24 早指",           cc_params: { initial_main_min: 1,  initial_read_sec:30, initial_extra_sec: 0,  every_plus:0, }, },
      { name: "将棋倶楽部24 早指2",          cc_params: { initial_main_min: 0,  initial_read_sec:30, initial_extra_sec: 60, every_plus:0, }, },
      { name: "将棋倶楽部24 15分",           cc_params: { initial_main_min: 15, initial_read_sec:60, initial_extra_sec: 0,  every_plus:0, }, },
      { name: "将棋倶楽部24 長考",           cc_params: { initial_main_min: 30, initial_read_sec:60, initial_extra_sec: 0,  every_plus:0, }, },
      { name: "ABEMA ﾌｨｯｼｬｰﾙｰﾙ 5分 +5秒/手", cc_params: { initial_main_min: 5,  initial_read_sec:0,  initial_extra_sec: 0,  every_plus:5, }, },
    ]
  }
}
