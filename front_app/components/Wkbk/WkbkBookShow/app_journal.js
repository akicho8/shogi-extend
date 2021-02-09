import dayjs from "dayjs"
import { OxInfo } from "../models/ox_info.js"
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
        this.journal_record("o")
        this.current_index += 1
      }
      if (this.current_article) {
        this.journal_next_init()
        this.journal_record("x")
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
    journal_record(ox) {
      this.interval_counter.stop()
      this.journal_hash[this.current_article.id].ox = ox
    },

    // 次の問題の準備
    journal_next_init() {
      this.$set(this.journal_hash, this.current_article.id, {spent_sec: 0, ox: null})
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
      const ox_info = this.journal_ox_info_for(article)
      if (ox_info) {
        return ox_info.icon_attrs
      }
    },

    // article の ox_info を返す
    journal_ox_info_for(article) {
      if (this.journal_hash) {
        const e = this.journal_hash[article.id]
        if (e != null) {
          if (e.ox != null) {
            return OxInfo.fetch(e.ox)
          }
        }
      }
    },

    // 不正解のみ残す
    articles_find_all_x_handle() {
      this.sound_play("click")
      this.book.articles = this.book.articles.filter(e => {
        const ox_info = this.journal_ox_info_for(e)
        if (ox_info) {
          return ox_info.key === "x"
        }
      })
    },
  },
  computed: {
    OxInfo() { return OxInfo },

    // 現在表示している問題の経過時間表記
    current_journal_time_to_s() {
      return this.journal_row_time_format_at(this.current_article)
    },

    // 「不正解のみ残す」が動作するか？
    articles_find_all_x_enabled() {
      return this.journal_ox_counts.x >= 1 && (this.journal_ox_counts.o >= 1 || this.journal_ox_counts.blank >= 1)
    },

    // 正解/不正解/空 の個数を返す
    // {o: 1 x: 0, blank: 10} 形式
    journal_ox_counts() {
      const a = this.OxInfo.values.reduce((a, e) => ({...a, [e.key]: 0}), {}) // {o: 0, x: 0}
      a["blank"] = 0
      if (false) {
        return _.reduce(this.journal_hash || {}, (a, e) => {
          const ox = e.ox ?? "blank"
          if (e.ox) {
            a[e.ox] = (a[e.ox] ?? 0) + 1
          }
          return a
        }, a)
      } else {
        return this.book.articles.reduce((a, article) => {
          const hash = this.journal_hash || {}
          const e = hash[article.id]
          let ox = "blank"
          if (e) {
            if (e.ox) {
              ox = e.ox
            }
          }
          a[ox] = (a[ox] || 0) + 1
          return a
        }, a)
      }
    }
  },
}
