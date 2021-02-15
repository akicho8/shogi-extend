import { IntervalCounter } from '@/components/models/interval_counter.js'
import dayjs from "dayjs"

export const app_tweet = {
  data() {
    return {
      interval_counter: null,
      correct_count: 0,
      mistake_count: 0,
      total_sec: 0,
      recent_summary: null,  // ツイート内容はリアクティブに変化しないようにあえて変数に保存しておく
      begin_pos: null,
    }
  },

  beforeMount() {
    this.interval_counter = new IntervalCounter(() => this.journal_counter())
  },

  beforeDestroy() {
    if (this.interval_counter) {
      this.interval_counter.stop()
      this.interval_counter = null
    }
  },

  methods: {
    ox_start() {
      this.correct_count = 0
      this.mistake_count = 0
      this.total_sec = 0
      this.journal_init()
      this.interval_counter.restart()
      this.begin_pos = this.current_index
    },

    ox_stop() {
      this.recent_summary = this.recent_summary_generate()
      this.jo_summary = this.jo_summary_generate()
      this.interval_counter.stop()
    },

    ox_apply(answer_kind_info) {
      this.sound_play(answer_kind_info.key)
      this.journal_record(answer_kind_info.key)
      this.$data[`${answer_kind_info.key}_count`] += 1
    },

    recent_summary_generate() {
      let out = ""
      out += `正解率: ${this.ox_rate_per} (${this.correct_count}/${this.ox_total})\n`
      out += `範囲: ${this.begin_pos + 1}〜${this.current_index}\n`
      out += `タイム: ${this.ox_spent_sec_to_s}\n`
      out += `平均: ${this.ox_time_avg}\n`
      return out
    },

    ox_tweet_body_wrap(str) {
      let out = ""
      out += "\n"
      out += `${this.book.title}\n`
      if (str) {
        out += str
      }
      out += "#" + "インスタント将棋問題集" + "\n"
      out += this.location_url_without_search_and_hash()
      return out
    },
  },

  computed: {
    o_count_max() {
      return this.book.xitems.length
    },

    ox_tweet_url() {
      return this.tweet_url_build_from_text(this.ox_tweet_body1)
    },

    ox_tweet_body1() {
      return this.ox_tweet_body_wrap(this.recent_summary)
    },

    ox_tweet_body2() {
      return this.ox_tweet_body_wrap(this.jo_summary)
    },

    ox_rate_per() {
      if (this.ox_total === 0) {
        return "0%"
      } else {
        return this.float_to_perc2(this.ox_rate) + "%"
      }
    },

    ox_rate() {
      return this.correct_count / this.ox_total
    },

    ox_total() {
      return this.correct_count + this.mistake_count
    },

    ox_rest() {
      return this.o_count_max - this.correct_count
    },

    ox_spent_sec_to_s() {
      return dayjs.unix(this.total_sec).format("m:ss")
    },

    ox_time_avg() {
      if (this.ox_total === 0) {
        return "?"
      } else {
        return dayjs.unix(this.total_sec / this.ox_total).format("m:ss.SSS")
      }
    },
  },
}
