//////////////////////////////////////////////////////////////////////////////// dayjs
import dayjs from "dayjs"

import "dayjs/locale/ja.js"
dayjs.locale('ja')

// import timezone from "dayjs/plugin/timezone.js"
// import utc from "dayjs/plugin/utc.js"
// dayjs.extend(timezone)
// dayjs.extend(utc)
// dayjs.tz.setDefault("Asia/Tokyo")

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
      t = dayjs(t)
      // t = t.hour(0).minute(0).second(0)
      // return t
      // const today = dayjs().hour(0).minute(0).second(0)
      // return t.isSame(today, "day")
      // return today
      // const yesterday = today.add(-1, "day")
      let v = null
      // if (t.isSame(today, "day")) {
      //   v = "本日"
      // } else if (t.isSame(yesterday, "day")) {
      //   v = "昨日"
      // } else {
      v = t.fromNow()
      // }
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
