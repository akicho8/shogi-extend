//////////////////////////////////////////////////////////////////////////////// dayjs
import dayjs from "dayjs"

import "dayjs/locale/ja.js"
dayjs.locale('ja')

// // https://github.com/iamkun/dayjs/blob/master/docs/ja/Plugin.md#isbetween
// import isBetween from 'dayjs/plugin/isBetween'
// dayjs.extend(isBetween)

// https://github.com/iamkun/dayjs/blob/master/docs/ja/Plugin.md#relativetime
import relativeTime from 'dayjs/plugin/relativeTime'
dayjs.extend(relativeTime)

export default {
  methods: {
    // debug console 用
    // GVI.dayjs()
    dayjs(...args) {
      return dayjs(...args)
    },

    dayjs_format(time, format) {
      return dayjs(time).format(format)
    },

    // https://day.js.org/docs/en/parse/string-format
    row_time_format(t) {
      const date = dayjs(t)
      const diff_day = dayjs().diff(date, "day")
      const diff_year = dayjs().diff(date, "year")
      if (diff_day < 1) {
        return date.format("H:mm")
      }
      if (diff_year < 1) {
        return date.format("M/D")
      }
      return date.format("YYYY-MM-DD")
    },

    // 「N分前」形式
    diff_time_format(t) {
      // const now = dayjs()
      return dayjs(t).fromNow()
    },

    updated_time_format(t) {
      const date = dayjs(t)
      // const diff_hour = dayjs().diff(date, "hour")
      const diff_day = dayjs().diff(date, "day")
      let v = null
      if (diff_day === 0) {
        v = "本日"
      } else if (diff_day === 1) {
        v = "昨日"
      } else {
        v = date.fromNow()
      }
      return v + "更新"
    },

    date_to_custom_format(t) {
      return dayjs(t).format(this.md_or_yyyymmdd_format(t))
    },

    md_or_yyyymmdd_format(t) {
      const date = dayjs(t)
      if (date.year() === dayjs().year()) {
        return "M / D"
      } else {
        return "YYYY-MM-DD"
      }
    },

    date_to_ymd(t) {
      return dayjs(t).format("YYYY-MM-DD")
    },

    date_to_wday(t) {
      return dayjs(t).format("ddd")
    },
  },
}
