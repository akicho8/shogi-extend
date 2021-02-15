import dayjs from "dayjs"
import { AnswerKindInfo } from "../models/answer_kind_info.js"
import _ from "lodash"

export const app_journal = {
  data() {
    return {
    }
  },
  methods: {
    // 開発テスト用
    journal_test() {
      this.journal_init()
      this.current_index = 0
      if (this.current_xitem) {
        this.journal_next_init()
        this.journal_record("correct")
        this.current_index += 1
      }
      if (this.current_xitem) {
        this.journal_next_init()
        this.journal_record("mistake")
        this.current_index += 1
      }
      this.ox_stop()
    },

    // 最初に呼ぶ
    journal_init() {
      this.book.xitems.forEach(xitem => {
        xitem.latest_answer_log = {
          answer_kind_key: null,
          spent_sec: null,
        }
      })
    },

    // 時間を進める
    journal_counter() {
      // this.journal_hash[this.current_xitem.id].spent_sec += 1
      this.current_xitem.latest_answer_log.spent_sec += 1
      this.spent_sec += 1
    },

    // O or X を選択したとき
    journal_record(answer_kind_key) {
      this.interval_counter.stop()
      this.current_xitem.latest_answer_log.answer_kind_key = answer_kind_key
      this.current_xitem.answer_stat[`${answer_kind_key}_count`] += 1
      this.journal_ox_create(answer_kind_key)
    },

    // O or X を記録
    journal_ox_create(answer_kind_key) {
      if (this.g_current_user) {
        const params = {
          article_id: this.current_article.id,
          answer_kind_key: answer_kind_key,
          book_id: this.book.id,
          spent_sec: this.current_xitem_spent_sec,
        }
        return this.$axios.$post("/api/wkbk/answer_logs/create.json", params).catch(e => {
          this.$nuxt.error(e.response.data)
          return
        }).then(e => {
          this.debug_alert(`ox_create ${e.id}`)
        })
      }
    },

    // 次の問題の準備
    journal_next_init() {
      // this.$set(this.journal_hash, this.current_xitem.id, {spent_sec: 0, answer_kind_key: null})

      this.current_xitem.latest_answer_log.spent_sec = 0
      this.current_xitem.latest_answer_log.answer_kind_key = null

      this.interval_counter.restart()
    },

    // b-table の時間用
    journal_row_time_format_at(xitem) {
      const v = xitem.latest_answer_log.spent_sec
      if (v != null) {
        return dayjs.unix(v).format("m:ss")
      }
    },

    // b-table の解答用
    journal_row_icon_attrs_for(xitem) {
      const answer_kind_info = this.journal_answer_kind_info_for(xitem)
      if (answer_kind_info) {
        return answer_kind_info.icon_attrs
      }
    },

    // article の answer_kind_info を返す
    journal_answer_kind_info_for(xitem) {
      const v = xitem.latest_answer_log.answer_kind_key
      if (v) {
        return AnswerKindInfo.fetch(v)
      }
      // if (this.journal_hash) {
      //   const e = this.journal_hash[article.id]
      //   if (e != null) {
      //     if (e.answer_kind_key != null) {
      //       return AnswerKindInfo.fetch(e.answer_kind_key)
      //     }
      //   }
      // }
    },
  },
  computed: {
    AnswerKindInfo() { return AnswerKindInfo },

    // 現在表示している問題の経過時間
    current_xitem_spent_sec() {
      return this.current_xitem.latest_answer_log.spent_sec
    },

    // 現在表示している問題の経過時間表記
    current_journal_time_to_s() {
      return this.journal_row_time_format_at(this.current_xitem)
    },

    // 「不正解のみ残す」が動作するか？
    xitems_find_all_x_enabled() {
      return this.journal_ox_counts.mistake >= 1 && (this.journal_ox_counts.correct >= 1 || this.journal_ox_counts.blank >= 1)
    },

    // 正解/不正解/空 の個数を返す
    // {correct: 1 mistake: 0, blank: 10} 形式
    journal_ox_counts() {
      const a = this.AnswerKindInfo.values.reduce((a, e) => ({...a, [e.key]: 0}), {})
      a["blank"] = 0
      // a => {correct: 0, mistake: 0, blank: 0}
      this.book.xitems.forEach(xitem => {
        a[xitem.latest_answer_log.answer_kind_key || "blank"] += 1
      })
      return a
    }
  },
}
