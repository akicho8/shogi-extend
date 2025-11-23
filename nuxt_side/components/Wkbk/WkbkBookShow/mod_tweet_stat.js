import dayjs from "dayjs"
import { AnswerKindInfo } from "../models/answer_kind_info.js"
import _ from "lodash"

export const mod_tweet_stat = {
  data() {
    return {
      current_spent_sec: null,        // 現在の問題に切り替わってからの経過時間
    }
  },
  methods: {
    st_init() {
      this.current_index = 0

      this.xitems.forEach(e => {
        this.difficulty_rate_update(e.answer_stat)
      })

      if (process.client) {
        this.app_log(`将棋ドリル→${this.book.title}`)
        this.talk(this.book.title)
        if (this.development_p && false) {
          this.journal_test()
        }
      }
    },

    // 開発テスト用
    journal_test() {
      this.st_ox_start()
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
      this.re_ox_stop()
    },

    // 開始時のフック
    st_ox_start() {
    },

    // 終了時フック
    st_ox_stop() {
    },

    // 次の問題の準備
    journal_next_init() {
      this.current_spent_sec = 0
      this.interval_counter.restart()

      if (false) {
        this.talk(this.current_article.title)
      }
    },

    // O or X を選択したとき
    journal_record(answer_kind_key) {
      this.interval_counter.stop()

      // 「START」してからの経過時間を確定する
      this.re_total_sec += this.current_spent_sec

      // 直近のログ
      {
        const e = this.current_xitem.newest_answer_log
        e.spent_sec = this.current_spent_sec
        e.answer_kind_key = answer_kind_key
      }

      // 統計
      {
        const e = this.current_xitem.answer_stat
        e[`${answer_kind_key}_count`] += 1
        e.spent_sec_total = (e.spent_sec_total || 0) + this.current_spent_sec
        this.difficulty_rate_update(e)
      }

      this.answer_log_create(answer_kind_key)
    },

    // O or X を記録
    answer_log_create(answer_kind_key) {
      if (this.g_current_user) {
        const params = {
          article_id: this.current_article.id,
          answer_kind_key: answer_kind_key,
          book_id: this.book.id,
          spent_sec: this.current_spent_sec,
        }
        return this.$axios.$post("/api/wkbk/answer_logs/create.json", params, {progress: false}).then(e => {
          if (e.id) {
            this.debug_alert(`ox_create ${e.id}`)
          }
          if (e.message) {
            this.toast_primary(e.message)
          }
        })
      }
    },

    table_time_format(v) {
      if (v != null) {
        let f = null
        if (v >= 60 * 60 * 24) {
          const h = Math.trunc(v / (60 * 60))
          return `${h}H`
        } else if (v >= 60 * 60) {
          f = "H:mm:ss"
        } else {
          f = "m:ss"
        }
        return dayjs.unix(v).format(f)
      }
    },

    // b-table の解答用
    journal_row_icon_attrs_for(xitem) {
      return this.journal_answer_kind_info_for(xitem)?.icon_attrs
    },

    // article の answer_kind_info を返す
    journal_answer_kind_info_for(xitem) {
      const v = xitem.newest_answer_log.answer_kind_key
      if (v) {
        return AnswerKindInfo.fetch(v)
      }
    },

    difficulty_rate_update(e) {
      const v = this.difficulty_rate_value(e)
      if (v != null) {
        e.difficulty_rate = v
      }
    },

    difficulty_rate_value(e) {
      const o = e.correct_count || 0
      const x = e.mistake_count || 0
      const t = o + x
      if (t >= 1) {
        return o / t
      }
    },

    difficulty_rate_human(e) {
      const v = this.difficulty_rate_value(e)
      if (v == null) {
        return ""
      }
      return this.$GX.number_truncate(v) * 100 + "%"
    },
  },
  computed: {
    AnswerKindInfo() { return AnswerKindInfo },

    // 現在表示している問題の経過時間表記
    navbar_display_time() {
      return this.table_time_format(this.current_spent_sec)
    },

    // 「不正解のみ残す」が動作するか？
    xitems_find_all_x_enabled() {
      return this.jo_counts.mistake >= 1 && (this.jo_counts.correct >= 1 || this.jo_counts.blank >= 1)
    },

    // 正解/不正解/空 の個数を返す
    // {correct: 1 mistake: 0, blank: 10} 形式
    jo_counts() {
      const a = this.AnswerKindInfo.values.reduce((a, e) => ({...a, [e.key]: 0}), {})
      a["blank"] = 0
      // a => {correct: 0, mistake: 0, blank: 0}
      this.book.xitems.forEach(xitem => {
        a[xitem.newest_answer_log.answer_kind_key || "blank"] += 1
      })
      return a
    },

    // クリア率
    st_clear_rate() {
      if (this.max_count === 0) {
        return "0%"
      }
      return this.$GX.number_truncate(this.jo_counts.correct / this.max_count * 100, 2) + "%"
    },

    st_ox_rate() {
      if (this.jo_ox_total === 0) {
        return "0%"
      }
      return this.$GX.number_truncate(this.jo_counts.correct / this.jo_ox_total * 100, 2) + "%"
    },

    jo_ox_total() {
      return this.jo_counts.correct + this.jo_counts.mistake
    },

    jo_total_sec() {
      return _.sumBy(this.xitems, e => e.newest_answer_log.spent_sec || 0)
    },

    jo_time_avg() {
      if (this.jo_ox_total === 0) {
        return "?"
      }
      const sec = this.jo_total_sec / this.jo_ox_total
      if (sec < 10) {
        return dayjs.unix(sec).format("s.SSS") + "秒"
      }
      if (sec < 60) {
        return dayjs.unix(sec).format("s") + "秒"
      }
      return dayjs.unix(sec).format("m分s秒")
    },

    st_summary() {
      let out = ""
      out += `達成率 ${this.st_clear_rate} (${this.jo_counts.correct}/${this.max_count})\n`
      out += `正解率 ${this.st_ox_rate} (${this.jo_counts.correct}/${this.jo_ox_total})\n`
      out += `平均 ${this.jo_time_avg}\n`
      out += `正解 ${this.jo_counts.correct}\n`
      out += `不正解 ${this.jo_counts.mistake}\n`
      out += `未解答 ${this.jo_counts.blank}\n`
      return out
    },

    current_difficulty_rate_human() {
      return this.difficulty_rate_human(this.current_xitem.answer_stat)
    },
  },
}
