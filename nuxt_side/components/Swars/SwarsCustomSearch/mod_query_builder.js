import dayjs from "dayjs"

import { CompareInfo    } from "./models/compare_info.js"
import { LogicalInfo    } from "./models/logical_info.js"
import { ParamInfo      } from "./models/param_info.js"

export const mod_query_builder = {
  methods: {
    // private

    // xxx:1,2 形式
    values_as_query(key, values) {
      let v = this.$GX.presence(values)
      if (v) {
        return [key, ":", v.join(",")].join("")
      }
    },

    // xxx:>=1 形式
    compare_value_as_query(key, enabled, compare, value) {
      if (enabled) {
        return `${key}:${compare.value}${value}`
      }
    },

    // xxx:2022-01-01..2022-01-02 形式
    date_range_as_query(key, range) {
      if (this.$GX.presence(range)) {
        const str = range.map(e => dayjs(e).format("YYYY-MM-DD")).join("..")
        return `${key}:${str}`
      }
    },
  },
  computed: {
    LogicalInfo()                     { return LogicalInfo                                        },
    CompareInfo()                     { return CompareInfo                                        },
    critical_turn_compare_info()      { return CompareInfo.fetch(this.critical_turn_compare)      },
    outbreak_turn_compare_info()      { return CompareInfo.fetch(this.outbreak_turn_compare)      },
    turn_max_compare_info()           { return CompareInfo.fetch(this.turn_max_compare)           },
    grade_diff_compare_info()         { return CompareInfo.fetch(this.grade_diff_compare)         },
    my_think_max_compare_info()       { return CompareInfo.fetch(this.my_think_max_compare)       },
    my_think_avg_compare_info()       { return CompareInfo.fetch(this.my_think_avg_compare)       },
    my_think_last_compare_info()      { return CompareInfo.fetch(this.my_think_last_compare)      },
    my_ai_wave_count_compare_info()   { return CompareInfo.fetch(this.my_ai_wave_count_compare)   },
    my_ai_drop_total_compare_info()   { return CompareInfo.fetch(this.my_ai_drop_total_compare) },

    new_query() {
      return this.$GX.str_squish([this.user_key, ...this.query_key_value_ary].join(" "))
    },

    new_query_without_user_key() {
      return this.$GX.presence(this.$GX.str_squish(this.query_key_value_ary.join(" ")))
    },

    // フォームと順番を合わせること
    query_key_value_ary() {
      let av = []
      av.push(this.values_as_query("持ち時間", this.rule_keys))
      av.push(this.values_as_query("勝敗", this.judge_keys))
      av.push(this.values_as_query("結末", this.final_keys))
      av.push(this.values_as_query("先後", this.location_keys))
      av.push(this.values_as_query("相手の棋力", this.grade_keys))
      av.push(this.compare_value_as_query("力差", this.grade_diff_enabled, this.grade_diff_compare_info, this.grade_diff))
      av.push(this.values_as_query("垢BAN", this.ban_keys))
      av.push(this.values_as_query(this.LogicalInfo.fetch(this.my_tag_values_op).search_key_for(false), this.my_tag_values))
      av.push(this.values_as_query(this.LogicalInfo.fetch(this.vs_tag_values_op).search_key_for(true),  this.vs_tag_values))
      av.push(this.values_as_query("自分の棋風", this.my_style_keys))
      av.push(this.values_as_query("相手の棋風", this.vs_style_keys))
      av.push(this.compare_value_as_query("手数", this.turn_max_enabled, this.turn_max_compare_info, this.turn_max))
      av.push(this.compare_value_as_query("中盤", this.outbreak_turn_enabled, this.outbreak_turn_compare_info, this.outbreak_turn))
      av.push(this.compare_value_as_query("開戦", this.critical_turn_enabled, this.critical_turn_compare_info, this.critical_turn))
      av.push(this.values_as_query("対局モード", this.xmode_keys))
      av.push(this.values_as_query("開始モード", this.imode_keys))
      av.push(this.values_as_query("手合割", this.preset_keys))
      av.push(this.date_range_as_query("日付", this.battled_at_range))
      av.push(this.values_as_query("対戦相手", this.vs_user_keys))
      av.push(this.compare_value_as_query("最大思考", this.my_think_max_enabled, this.my_think_max_compare_info, this.my_think_max))
      av.push(this.compare_value_as_query("平均思考", this.my_think_avg_enabled, this.my_think_avg_compare_info, this.my_think_avg))
      av.push(this.compare_value_as_query("最終思考", this.my_think_last_enabled, this.my_think_last_compare_info, this.my_think_last))
      av.push(this.compare_value_as_query("棋神波形数", this.my_ai_wave_count_enabled, this.my_ai_wave_count_compare_info, this.my_ai_wave_count))
      av.push(this.compare_value_as_query("棋神を模倣した指し手の数", this.my_ai_drop_total_enabled, this.my_ai_drop_total_compare_info, this.my_ai_drop_total))
      return av
    },
  },
}
