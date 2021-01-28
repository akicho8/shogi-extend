import { IntervalCounter } from '@/components/models/interval_counter.js'
import dayjs from "dayjs"

export const app_tweet = {
  data() {
    return {
      interval_counter: new IntervalCounter(() => this.spent_sec += 1),
      o_count: 0,
      x_count: 0,
      spent_sec: 0,
    }
  },

  beforeDestroy() {
    this.interval_counter.stop()
  },

  methods: {
    ox_start() {
      this.o_count = 0
      this.x_count = 0
      this.spent_sec = 0
      this.interval_counter.restart()
    },

    ox_stop() {
      this.interval_counter.stop()
    },

    ox_apply(o) {
      if (o) {
        this.sound_play("o")
        this.o_count += 1
      } else {
        this.sound_play("x")
        this.x_count += 1
      }
    },
  },

  computed: {
    ox_summary() {
      let out = ""
      out += `${this.book.title}\n`
      out += `正解率: ${this.ox_rate_per}% (${this.o_count}/${this.o_count_max})\n`
      out += `タイム: ${this.ox_spent_sec_to_s}\n`
      out += `平均: ${this.ox_time_avg}\n`
      return out
    },

    o_count_max() {
      return this.book.articles_count
    },

    ox_tweet_url() {
      return this.tweet_url_build_from_text(this.ox_tweet_body)
    },

    ox_tweet_body() {
      let out = ""
      out += this.ox_summary
      out += "#みんなの問題集\n"
      out += this.location_url_without_search_and_hash()
      return out
    },

    ox_rate_per() {
      if (this.ox_total === 0) {
        return "?"
      } else {
        return this.float_to_perc(this.ox_rate)
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
