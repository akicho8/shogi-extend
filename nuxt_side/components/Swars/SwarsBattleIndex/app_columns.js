import { ColumnInfo } from "./models/column_info.js"
import { JudgeInfo } from "../models/judge_info.js"

export const app_columns = {
  methods: {
    // 指定のカラムをトグル
    column_toggle_handle(info) {
      this.$set(this.visible_hash, info.key, !this.visible_hash[info.key])
      if (this.visible_hash[info.key]) {
        this.sound_play_toggle(true)
        this.talk(info.name)
      } else {
        this.sound_play_toggle(false)
      }
    },

    // すべてのカラムを表示する(デバッグ用)
    column_all_set(value) {
      this.ColumnInfo.values.forEach(e => this.$set(this.visible_hash, e.key, value))
    },

    // 指定のカラムは表示してよいか？
    column_visible_p(key) {
      // if (this.ColumnInfo.fetch(key).available_p(this)) {
      return this.visible_hash[key]
      // }
    },
  },
  computed: {
    ColumnInfo() { return ColumnInfo },
    JudgeInfo() { return JudgeInfo  },

    // 操作の列を表示する？
    operation_any_column_visible_p() {
      return this.base.ColumnInfo.operation_records.some(e => this.base.column_visible_p(e.key))
    },
  },
}
