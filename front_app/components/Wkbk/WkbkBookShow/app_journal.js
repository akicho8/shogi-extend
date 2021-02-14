import dayjs from "dayjs"
import { OxMarkInfo } from "../models/ox_mark_info.js"
import _ from "lodash"

export const app_journal = {
  data() {
    return {
      journal_hash: null, // article.id をキーにして値に正解/不正解と時間を持つハッシュ
    }
  },
  methods: {
    // 開発テスト用
    journal_test() {
      this.journal_init()
      this.current_index = 0
      if (this.current_article) {
        this.journal_next_init()
        this.journal_record("correct")
        this.current_index += 1
      }
      if (this.current_article) {
        this.journal_next_init()
        this.journal_record("mistake")
        this.current_index += 1
      }
      this.ox_stop()
    },

    // 最初に呼ぶ
    journal_init() {
      this.journal_hash = {}
    },

    // 時間を進める
    journal_counter() {
      this.journal_hash[this.current_article.id].spent_sec += 1
      this.spent_sec += 1
    },

    // O or X を選択したとき
    journal_record(ox_mark_key) {
      this.interval_counter.stop()
      this.journal_hash[this.current_article.id].ox_mark_key = ox_mark_key
      this.journal_ox_create(ox_mark_key)
    },

    // O or X を記録
    journal_ox_create(ox_mark_key) {
      if (this.g_current_user) {
        const params = {
          book_id: this.book.id,
          article_id: this.current_article.id,
          spent_sec: this.current_article_spent_sec,
          ox_mark_key: ox_mark_key,
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
      this.$set(this.journal_hash, this.current_article.id, {spent_sec: 0, ox_mark_key: null})
      this.interval_counter.restart()
    },

    // b-table の時間用
    journal_row_time_format_at(article) {
      const e = this.journal_hash[article.id]
      if (e != null) {
        if (e.spent_sec != null) {
          return dayjs.unix(e.spent_sec).format("m:ss")
        }
      }
    },

    // b-table の解答用
    journal_row_icon_attrs_for(article) {
      const ox_mark_info = this.journal_ox_mark_info_for(article)
      if (ox_mark_info) {
        return ox_mark_info.icon_attrs
      }
    },

    // article の ox_mark_info を返す
    journal_ox_mark_info_for(article) {
      if (this.journal_hash) {
        const e = this.journal_hash[article.id]
        if (e != null) {
          if (e.ox_mark_key != null) {
            return OxMarkInfo.fetch(e.ox_mark_key)
          }
        }
      }
    },
  },
  computed: {
    OxMarkInfo() { return OxMarkInfo },

    // 現在表示している問題の経過時間
    current_article_spent_sec() {
      return this.journal_hash[this.current_article.id].spent_sec
    },

    // 現在表示している問題の経過時間表記
    current_journal_time_to_s() {
      return this.journal_row_time_format_at(this.current_article)
    },

    // 「不正解のみ残す」が動作するか？
    articles_find_all_x_enabled() {
      return this.journal_ox_counts.mistake >= 1 && (this.journal_ox_counts.correct >= 1 || this.journal_ox_counts.blank >= 1)
    },

    // 正解/不正解/空 の個数を返す
    // {correct: 1 mistake: 0, blank: 10} 形式
    journal_ox_counts() {
      const a = this.OxMarkInfo.values.reduce((a, e) => ({...a, [e.key]: 0}), {}) // {correct: 0, mistake: 0}
      a["blank"] = 0
      if (false) {
        return _.reduce(this.journal_hash || {}, (a, e) => {
          const ox_mark_key = e.ox_mark_key || "blank"
          if (e.ox_mark_key) {
            a[e.ox_mark_key] = (a[e.ox_mark_key] || 0) + 1
          }
          return a
        }, a)
      } else {
        return this.book.articles.reduce((a, article) => {
          const hash = this.journal_hash || {}
          const e = hash[article.id]
          let ox_mark_key = "blank"
          if (e) {
            if (e.ox_mark_key) {
              ox_mark_key = e.ox_mark_key
            }
          }
          a[ox_mark_key] = (a[ox_mark_key] || 0) + 1
          return a
        }, a)
      }
    }
  },
}
