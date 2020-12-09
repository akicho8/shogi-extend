import dayjs from "dayjs"

// https://github.com/iamkun/dayjs/blob/master/docs/ja/Plugin.md#isbetween
import isBetween from 'dayjs/plugin/isBetween'
dayjs.extend(isBetween)

export class TimeSupport {
  // 有効な時間帯か？
  //   time_range_active_p({beg: "23:00", end: "23:15"})
  static time_range_active_p(range) {
    if (range === true) {
      return true
    }
    if (range === false) {
      return false
    }
    const beg = this.hhmm_to_today(range.beg)
    const end = this.hhmm_to_today(range.end)
    return dayjs().isBetween(beg, end, null, "[)") // (beg...end).cover?(now)
  }

  static time_ranges_active_p(list) {
    return list.some(e => this.time_range_active_p(e))
  }

  // // 今日の時間帯に調整した範囲を返す
  // // おわりが 25:00 の場合は昨日からの換算とする
  // static beg_end_to_objects(e) {
  //   const ymd = dayjs().format("YYYY-MM-DD")
  //   return {
  //     beg: dayjs(`${ymd} ${e.beg}`),
  //     end: dayjs(`${ymd} ${e.end}`),
  //   }
  // }

  // "23:00" を今日の 23:00 した dayjs のインスタンス返す
  static hhmm_to_today(hhmm) {
    const ymd = dayjs().format("YYYY-MM-DD")
    return dayjs(`${ymd} ${hhmm}`)
  }

  // // 今日の時間帯に調整した範囲の配列を返す
  // get normalized_time_ranges() {
  //   return this.raw_time_ranges.map(e => this.constructor.beg_end_to_objects(e))
  // }
}
