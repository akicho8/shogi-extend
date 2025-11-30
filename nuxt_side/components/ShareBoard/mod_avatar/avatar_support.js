// |--------------------+----------------------------------------------|
// | methods            | desc                                         |
// |--------------------+----------------------------------------------|
// | char_from_str(str) | str から絵文字1文字に変換する                |
// | record_find(str)   | 文字列のなかから最初1件の絵文字情報を得る    |
// | record_find_all(str)   | 文字列のなかに存在するすべて絵文字情報を得る |
// |--------------------+----------------------------------------------|

import _ from "lodash"
import { GX } from "@/components/models/gx.js"
import dayjs from "dayjs"
import { parse as TwitterEmojiParser } from "@twemoji/parser"
import { AppConfig } from "../models/mod_app_config.js"
import { AvailableChars } from "./available_chars.js"

export const AvatarSupport = {
  AvailableChars,

  // str から絵文字1文字に変換する
  // メモ化したくなるが絶対すな
  char_from_str(str) {
    const pepper = dayjs().format(AppConfig.avatar.pepper_date_format)
    const hash_number = GX.str_to_hash_number([pepper, str].join("-"))
    return GX.ary_cycle_at(AvailableChars, hash_number)
  },

  // 文字列のなかから最初1件の絵文字情報を得る
  record_find(str) {
    return this.record_find_all(str)[0]
  },

  // 文字列のなかに存在するすべて絵文字情報を得る
  record_find_all(str) {
    GX.assert_kind_of_string(str)
    return TwitterEmojiParser(str)
  },

  // 正確な表示文字数を得る
  chars_count(str) {
    const segmenter = new Intl.Segmenter("ja", { granularity: "grapheme" })
    return [...segmenter.segment(str)].length
  },

  // 正常でも何か入っているので注意な
  validate_message(str) {
    if (GX.blank_p(str)) {
      return {
        type: "is-primary",
        message: "空のままでも良いです (自動で決まります)",
      }
    }
    if (!this.record_find(str)) {
      return {
        type: "is-danger",
        message: "絵文字を入力しよう",
      }
    }
    if (this.chars_count(str) > 1) {
      return {
        type: "is-danger",
        message: `ひとつだけ入力しよう`,
      }
    }
    return {
      type: "is-success",
      message: "OK",
    }
  },
}
