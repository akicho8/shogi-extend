import { Xinteger } from "./xinteger.js"

export const Xtime = {
  // 指定の秒数を人間表記にする
  //  xtime_format_human_hms(1)    // => "1秒"
  //  xtime_format_human_hms(90)   // => "1分30秒"
  //  xtime_format_human_hms(3600) // => "1時間0分"
  xtime_format_human_hms(seconds) {
    let format = ""
    if (seconds < 60) {
      return `${seconds}秒`
    } else if (seconds < 60 * 60) {
      const [m, s] = Xinteger.idivmod(seconds, 60)
      return `${m}分${s}秒`
    } else {
      const [h, m] = Xinteger.idivmod(seconds, 60 * 60)
      return `${h}時間${m}分`
    }
  },
}
