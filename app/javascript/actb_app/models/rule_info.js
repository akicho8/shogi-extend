import MemoryRecord from 'js-memory-record'

import dayjs from "dayjs"

// https://github.com/iamkun/dayjs/blob/master/docs/ja/Plugin.md#isbetween
import isBetween from 'dayjs/plugin/isBetween'
dayjs.extend(isBetween)

export class RuleInfo extends MemoryRecord {
  // 今日の時間帯に調整した範囲の配列を返す
  static time_active_p(range) {
    return dayjs().isBetween(range.beg, range.end, null, "[)") // (today_begin...today_end).cover?(now)
  }

  // 今日の時間帯に調整した範囲を返す
  // おわりが 25:00 の場合は昨日からの換算とする
  static beg_end_to_objects(e) {
    const ymd = dayjs().format("YYYY-MM-DD")
    return {
      beg: dayjs(`${ymd} ${e.beg}`),
      end: dayjs(`${ymd} ${e.end}`),
    }
  }

  // 今日の時間帯に調整した範囲の配列を返す
  get normalized_time_ranges() {
    return this.raw_time_ranges.map(e => this.constructor.beg_end_to_objects(e))
  }

  // 開催中か？
  get time_active_p() {
    return this.normalized_time_ranges.some(e => this.constructor.time_active_p(e))
  }
}
