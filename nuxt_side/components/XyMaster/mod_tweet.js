import dayjs from "dayjs"

export const mod_tweet = {
  data() {
    return {
      o_count:       null, // 正解数
      x_count:       null, // 不正解数
      micro_seconds: null, // 経過時間
      entry_name:    null, // ランキングでの名前を保持しておく
      latest_rule:   null, // 最後に挑戦した最新のルール
    }
  },
  methods: {
    magic_number() {
      return dayjs().format("YYMMDDHHmm")
    },
  },
  computed: {
    summary() {
      let out = ""
      if (this.latest_rule) {
        out += `ルール: ${this.latest_rule.name}\n`
      }
      if (this.time_record) {
        out += `本日: ${this.time_record.rank_info.scope_today.rank}位\n`
        out += `全体: ${this.time_record.rank_info.scope_all.rank}位\n`
      }
      out += `タイム: ${this.time_format}`
      if (this.time_record) {
        if (this.time_record.best_update_info) {
          out += ` (${this.time_record.best_update_info.updated_spent_sec}秒更新)`
        }
      }
      out += `\n`
      if (this.time_avg) {
        out += `平均: ${this.time_avg}秒\n`
      }
      out += `不正解: ${this.x_count}\n`
      out += `正解率: ${this.rate_per}%\n`
      return out
    },

    o_count_max() {
      return this.latest_rule.o_count_max
    },

    tweet_url() {
      return this.tweet_url_build_from_text(this.tweet_body)
    },

    tweet_body() {
      let out = ""
      out += this.summary
      out += "#" + "符号の鬼" + "\n"
      out += this.location_url_without_search_and_hash() + "?" + this.magic_number()
      return out
    },

    rate_per() {
      return this.$GX.floatx100_percentage(this.rate)
    },

    rate() {
      if (this.total_count === 0) {
        return 0
      }
      return this.o_count / this.total_count
    },

    total_count() {
      return this.o_count + this.x_count
    },

    count_rest() {
      return this.o_count_max - this.o_count
    },

    time_format() {
      return this.time_format_from_msec(this.spent_sec)
    },

    time_avg() {
      if (this.o_count >= 1) {
        return dayjs.unix(this.spent_sec / this.o_count).format("s.SSS")
      }
    },

    spent_sec() {
      return this.micro_seconds / 1000
    },
  },
}
