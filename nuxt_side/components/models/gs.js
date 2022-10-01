import { Gs2 } from "./gs2.js"
import { Gs3 } from "./gs3.js"
import _ from "lodash"
import dayjs from "dayjs"
import { HandleNameParser } from "./handle_name_parser.js"
import { ScreenSizeDetector } from "./screen_size_detector.js"

import { DotSfen } from "@/components/models/dot_sfen.js"

const KANJI_TO_HANKAKU_NUMBER_TABLE = {
  "〇": "0",
  "一": "1",
  "二": "2",
  "三": "3",
  "四": "4",
  "五": "5",
  "六": "6",
  "七": "7",
  "八": "8",
  "九": "9",
}

// vue_support.js の methods に追加する
export const Gs = {
  ...Gs2,
  ...Gs3,

  __trace__(scope, method) {
    if (!this.development_p) {
      return ""
    }
    let count = "-"
    let side = "SSR"
    if (typeof window !== 'undefined') {
      side = "CSR"
      if (window.$TRACE_COUNT_HASH == null) {
        window.$TRACE_COUNT_HASH = {}
      }
      const key = `${scope}.${method}`
      count = (window.$TRACE_COUNT_HASH[key] ?? 0) + 1
      window.$TRACE_COUNT_HASH[key] = count
    }
    console.log(`[${side}][${scope}] ${method} (${count})`)
    return ""
  },

  // Bulma のマクロの JS 版
  // +mobile 相当は this.screen_match_p("mobile") とする
  screen_match_p(type) {
    return ScreenSizeDetector.match_p(type)
  },

  dot_sfen_escape(...args)   { return DotSfen.escape(...args)   }, // SFENの " " を "." に変更
  dot_sfen_unescape(...args) { return DotSfen.unescape(...args) }, // SFENの "." を " " に変更

  // kanji_hankaku_format("(三二)") => "(32)"
  kanji_hankaku_format(str) {
    return str.replace(/[〇一二三四五六七八九]/g, s => KANJI_TO_HANKAKU_NUMBER_TABLE[s])
  },

  // Gs.normalize_for_autocomplete("Ａ四") => "a4"
  normalize_for_autocomplete(str) {
    return this.kanji_hankaku_format(this.hankaku_format(str ?? "")).toLowerCase()
  },

  user_call_name(str) {
    return HandleNameParser.call_name(str)
  },

  // { a: 1, c: 3, b: 2, d: 4 }.sort_by { |k, v| -v }.take(3).to_h # => {:d=>4, :c=>3, :b=>2}
  //
  // ↓
  //
  // let list = this.hash_to_key_value_list(hash)
  // list = _.sortBy(list, [e => -e.value])
  // list = _.take(list, 3)
  // hash = this.key_value_list_to_hash(list)

  // hash を key, value のキーをもった配列にする
  hash_to_key_value_list(hash) {
    return _.reduce(hash, (a, value, key) => {
      a.push({key: key, value: value})
      return a
    }, [])
  },

  // key, value のキーをもった配列から hash に戻す
  key_value_list_to_hash(ary) {
    return ary.reduce((a, e) => ({...a, [e.key]: e.value}), {})
  },

  // counts_hash_reverse_sort_take({ a: 1, c: 3, b: 2, d: 4 }, 3) => {:d=>4, :c=>3, :b=>2}
  count_hash_reverse_sort_by_count_and_take(hash, n) {
    let list = this.hash_to_key_value_list(hash)
    list = _.sortBy(list, [e => -e.value])
    list = _.take(list, n)
    return this.key_value_list_to_hash(list)
  },

  ////////////////////////////////////////////////////////////////////////////////

  // シンプルなハッシュに変換
  //
  // [
  //   { key: "column1", visible: true, },
  //   { key: "column2", visible: true, },
  // ]
  //
  //   ↓
  //
  // { xxx: true, yyy: false }
  //
  as_visible_hash(v) {
    return _.reduce(v, (a, e) => ({...a, [e.key]: e.visible}), {})
  },

  ////////////////////////////////////////////////////////////////////////////////

  // 単純に value があるかないかでクラスを割り振る
  has_content_class(value, options = {}) {
    options = {
      present_class: "is_content_present",
      blank_class: "is_content_blank",
      ...options,
    }
    if (this.present_p(value)) {
      return options.present_class
    } else {
      return options.blank_class
    }
  },
}
