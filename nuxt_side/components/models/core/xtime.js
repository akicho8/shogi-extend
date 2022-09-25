import { Xinteger } from "./xinteger.js"

export const Xtime = {
  time_format_human_hms(seconds) {
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
