import _ from "lodash"
import dayjs from "dayjs"
import { AnySupport } from "./any_support.js"

export const HandleNameValidator = {
  valid_with_message(s) {
    s = _.trim(s)
    if (s.length === 0) {
      return "ハンドルネームを入力してください"
    }
    if (this.valid(s)) {
      return null
    } else {
      const pepper = dayjs().format("YYYY-MM-DD")
      const hash_number = AnySupport.hash_number_from_str([pepper, s].join("-"))
      const prefix = AnySupport.ary_cycle_at(this.prefix_list, hash_number)
      return `${prefix}ハンドルネームを入力してください`
    }
  },
  valid(s) {
    s = _.trim(s)
    let error = false
    if (!error) {
      error = (s.length === 0)
    }
    if (!error) {
      error = s.match(/[な名][な無]し|nanash?i|無名|通りすがり/i)
    }
    if (!error) {
      error = (s.length <= 1 && !s.match(/[一-龠]/))
    }
    if (!error) {
      error = s.match(/^(.)\1\1?$/i)
    }
    if (!error) {
      error = s.match(/(.)\1\1/i)
    }
    return !error
  },
  get prefix_list() {
    return [
      "友好的な",
      "真面目に",
      "親近感のある",
      "フレンドリーな",
      "親しみのある",
      "好感のある",
      "捨てハンでない",
      "愛嬌のある",
      "打ち解けやすい",
    ]
  },
}
