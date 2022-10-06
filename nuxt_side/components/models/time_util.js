// |---------------------|
// | dayjs(...args)      |
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

export const TimeUtil = {
  create(...args) {
    return dayjs(...args)
  },

  current_ms() {
    return dayjs().valueOf()
  },

  // テーブル内の行で表示する用
  // https://day.js.org/docs/en/parse/string-format
  format_row(t) {
    if (this.blank_p(t)) {
      return ""
    }
    const time = dayjs(t)
    const diff_day = dayjs().diff(time, "day")
    const diff_year = dayjs().diff(time, "year")
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
    return dayjs(t).fromNow()
  },

  format_md_or_ymd(t) {
    let format = "YYYY-MM-DD"
    const time = dayjs(t)
    if (time.year() === dayjs().year()) {
      format = "M / D"
    }
    return time.format(format)
  },

  format_ymd(t) {
    return dayjs(t).format("YYYY-MM-DD")
  },

  format_wday_name(t) {
    return dayjs(t).format("ddd")
  },
}
