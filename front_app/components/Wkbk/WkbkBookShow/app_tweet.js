import { IntervalCounter } from '@/components/models/interval_counter.js'
import dayjs from "dayjs"

export const app_tweet = {
  data() {
    return {
      interval_counter: null,
      o_count: 0,
      x_count: 0,
      spent_sec: 0,
      ox_summary: null,  // ツイート内容はリアクティブに変化しないようにあえて変数に保存しておく
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
      this.o_count = 0
      this.x_count = 0
      this.spent_sec = 0
      this.journal_init()
      this.interval_counter.restart()
    },

    ox_stop() {
      this.ox_summary = this.ox_summary_generate()
      this.interval_counter.stop()
    },

    ox_apply(ox_info) {
      this.sound_play(ox_info.key)
      this.journal_record(ox_info.key)
      if (ox_info.key === "o") {
        this.o_count += 1
      } else {
        this.x_count += 1
      }
    },

    ox_summary_generate() {
      let out = ""
      out += `${this.book.title}\n`
      out += `正解率: ${this.ox_rate_per} (${this.o_count}/${this.ox_total})\n`
      out += `タイム: ${this.ox_spent_sec_to_s}\n`
      out += `平均: ${this.ox_time_avg}\n`
      return out
    },
  },

  computed: {
    o_count_max() {
      return this.book.articles.length
    },

    ox_tweet_url() {
      return this.tweet_url_build_from_text(this.ox_tweet_body)
    },

    ox_tweet_body() {
      let out = ""
      out += "\n"
      out += this.ox_summary
      out += "#" + "インスタント将棋問題集" + "\n"
      out += this.location_url_without_search_and_hash()
      return out
    },

    ox_rate_per() {
      if (this.ox_total === 0) {
        return "0%"
      } else {
        return this.float_to_perc(this.ox_rate) + "%"
      }
    },

    ox_rate() {
      return this.o_count / this.ox_total
    },

    ox_total() {
      return this.o_count + this.x_count
    },

    ox_rest() {
      return this.o_count_max - this.o_count
    },

    ox_spent_sec_to_s() {
      return dayjs.unix(this.spent_sec).format("m:ss")
    },

    ox_time_avg() {
      if (this.o_count === 0) {
        return "?"
      } else {
        return dayjs.unix(this.spent_sec / this.o_count).format("m:ss.SSS")
      }
    },
  },
}
