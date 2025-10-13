// |---------------------|
// | create(...args)     |
// | current_ms()        |
// | format_row(t)       |
// | format_diff(t)      |
// | format_md_or_ymd(t) |
// | format_ymd(t)       |
// | format_wday_name(t) |
// |---------------------|

import dayjs from "dayjs"

import "dayjs/locale/ja.js"
dayjs.locale("ja")

// 相対日時対応
// https://zenn.dev/catnose99/articles/ba540f5c233847
// dayjs('2021-01-24T01:00:00').fromNow() // => 1時間前
import relativeTime from "dayjs/plugin/relativeTime"
dayjs.extend(relativeTime)

import { GX } from "@/components/models/gx.js"

export const TimeUtil = {
  create(...args) {
    return dayjs(...args)
  },

  current_ms() {
    return this.create().valueOf()
  },

  // テーブル内の行で表示する用
  // https://day.js.org/docs/en/parse/string-format
  format_row(t) {
    if (GX.blank_p(t)) {
      return ""
    }
    const time = this.create(t)
    const diff_day = this.create().diff(time, "day")
    const diff_year = this.create().diff(time, "year")
    if (diff_day < 1) {
      return time.format("H:mm")
    }
    if (diff_year < 1) {
      return time.format("M/D")
    }
    return time.format("YYYY-MM-DD")
  },

  // 「N分前」形式
  format_diff(t) {
    return this.create(t).fromNow()
  },

  format_md_or_ymd(t) {
    let format = null
    const time = this.create(t)
    if (time.year() === this.create().year()) {
      format = "M / D"
    } else {
      format = "YYYY-MM-DD"
    }
    return time.format(format)
  },

  format_ymd(t) {
    return this.create(t).format("YYYY-MM-DD")
  },

  format_wday_name(t) {
    return this.create(t).format("ddd")
  },

  format_hhmmss(t) {
    return this.create(t).format("HH:mm:ss")
  },
}
