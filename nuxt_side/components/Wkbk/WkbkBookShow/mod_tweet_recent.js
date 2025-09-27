import dayjs from "dayjs"

export const mod_tweet_recent = {
  data() {
    return {
      re_correct_count: null,
      re_mistake_count: null,
      re_total_sec: 0,
      re_summary: null,      // ツイート内容はリアクティブに変化しないように変数に保存しておく
      re_begin_index: null,  // 「START」を押した時点の current_index を保持しておく
    }
  },

  methods: {
    re_ox_start() {
      this.re_correct_count = 0
      this.re_mistake_count = 0
      this.re_total_sec = 0
      this.st_ox_start()
      this.interval_counter.restart()
      this.re_begin_index = this.current_index
    },

    re_ox_stop() {
      this.st_ox_stop()
      this.re_summary = this.re_summary_generate()
      this.interval_counter.stop()
    },

    re_ox_apply(answer_kind_info) {
      this.sfx_play(answer_kind_info.key)
      this.journal_record(answer_kind_info.key)
      this.$data[`re_${answer_kind_info.key}_count`] += 1
    },

    re_summary_generate() {
      let out = ""
      out += `正解率 ${this.re_ox_rate_per} (${this.re_correct_count}/${this.re_ox_total})\n`
      if (this.current_index <= this.re_begin_index) {
        out += `範囲: ${this.re_begin_index + 1}〜?\n`
      } else {
        out += `範囲: ${this.re_begin_index + 1}〜${this.current_index}\n`
      }
      out += `タイム: ${this.re_ox_spent_sec_to_s}\n`
      out += `平均: ${this.re_ox_time_avg}\n`
      return out
    },
  },

  computed: {
    re_o_count_max() {
      return this.book.xitems.length
    },

    re_ox_tweet_url() {
      return this.tweet_url_build_from_text(this.re_ox_tweet_body1)
    },

    re_ox_tweet_body1() {
      return this.tweet_body_wrap(this.re_summary)
    },

    re_ox_tweet_body2() {
      return this.tweet_body_wrap(this.st_summary)
    },

    re_ox_rate_per() {
      if (this.re_ox_total === 0) {
        return "0%"
      } else {
        return this.$gs.number_truncate(this.re_ox_rate * 100, 2) + "%"
      }
    },

    re_ox_rate() {
      return this.re_correct_count / this.re_ox_total
    },

    re_ox_total() {
      return this.re_correct_count + this.re_mistake_count
    },

    re_ox_rest() {
      return this.re_o_count_max - this.re_correct_count
    },

    re_ox_spent_sec_to_s() {
      return dayjs.unix(this.re_total_sec).format("m:ss")
    },

    re_ox_time_avg() {
      if (this.re_ox_total === 0) {
        return "?"
      } else {
        return dayjs.unix(this.re_total_sec / this.re_ox_total).format("m:ss.SSS")
      }
    },
  },
}
