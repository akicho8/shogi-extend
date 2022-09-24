import { Gs2 } from "./gs2.js"
import _ from "lodash"
import dayjs from "dayjs"
import { HandleNameParser } from "./handle_name_parser.js"
import { ScreenSizeDetector } from "./screen_size_detector.js"

import Extsprintf from 'extsprintf'

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

  short_inspect(value) { return JSON.stringify(value) },
  pretty_inspect(value) { return JSON.stringify(value, null, 4)   },
  // inspect(value)        { return JSON.stringify(value)            },
  pretty_print(value)   { console.log(this.pretty_inspect(value)) },
  // p(value)              { console.log(this.inspect(value))        },
  // a(value)              { alert(this.inspect(value))              },
  pretty_alert(value)   { alert(this.pretty_inspect(value))       },

  ////////////////////////////////////////////////////////////////////////////////

  // float_to_perc(0.33, 2)    // => 33
  // float_to_perc(0.333, 2)   // => 33.3
  // float_to_perc(0.33333, 2) // => 33.33
  float_to_perc(v, precision = 0) {
    return this.number_floor(v * 100, precision)
  },

  // 0.1234 -> 12.34
  float_to_perc2(v) {
    const base = 100
    return Math.trunc(v * 100 * base) / base
  },

  // 0.1234 -> 12
  float_to_integer_percentage(v) {
    return Math.trunc(v * 100)
  },

  // number_floor(0.3, 2)   // => 0.3
  // number_floor(0.33, 2)  // => 0.33
  // number_floor(0.333, 2) // => 0.33
  number_floor(v, precision = 0) { return _.floor(v, precision) },
  number_ceil(v, precision = 0) { return _.ceil(v, precision) },
  number_round(v, precision = 0) { return _.round(v, precision) },

  // number_round_s(3.000, 1) // => "3.0"
  // number_round_s(3.456, 1) // => "3.5"
  number_round_s(v, precision = 0) { return v.toFixed(precision) },

  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////// tag


  // str から現在の手数を推測する
  // https://www.kento-shogi.com/?branch=B%2A8b.9c8c.8b7c%2B.7b7c.5b8b%2B.8c7d.P%2A7e.7d6c.8b6b.6c5d.6b5b&branchFrom=120&moves=2g2f.3c3d.2f2e.2b3c.2h2f.8b2b.4i3h.3a4b.2f3f.2c2d.2e2d.2b2d.P%2A2g.5a6b.9g9f.9c9d.7i6h.6b7b.3i4h.7a8b.6i7i.8c8d.5i5h.8b8c.8h9g.7b8b.9g7e.6a7b.7e6f.4c4d.3f2f.P%2A2e.2f5f.4a5b.5f4f.4b4c.3g3f.5b6b.4h3g.6c6d.7g7f.1c1d.1g1f.6b6c.5h4h.7c7d.4h3i.8a7c.5g5f.2d2b.6h5g.2b4b.5f5e.5c5d.5e5d.4c5d.5g5f.P%2A5e.5f5e.5d5e.6f5e.S%2A4e.4f4e.4d4e.5e3c%2B.2a3c.B%2A5a.4b5b.5a3c%2B.5b5i%2B.3i2h.5i7i.N%2A5e.R%2A5i.S%2A3i.B%2A5g.S%2A4h.5g4h%2B.3g4h.5i6i%2B.5e6c%2B.7b6c.7f7e.N%2A5f.P%2A5i.5f4h%2B.3i4h.4e4f.7e7d.4f4g%2B.7d7c%2B.6c7c.3h4g.P%2A4f.4g4f.G%2A4i.P%2A7d.8c7d.N%2A8f.4i4h.8f7d.7i7d.P%2A7e.7d7e.B%2A8f.7e8f.8g8f.B%2A3i.2h1h.4h3h.R%2A5b.P%2A7b.S%2A7a.8b9c.N%2A8e.8d8e.3c6f.N%2A8d.6f3i.3h3i.B%2A8b.9c8c.8b7c%2B.7b7c.G%2A8b.8c7d.P%2A7e.7d7e.5b5e%2B.N%2A6e.P%2A7f.8d7f.G%2A6f.7e8f.6f7f.8f8g#118
  // のURLから変換するときは現在局面 118 に合わせておきたい
  turn_guess(str) {
    const md = str.match(/http.*kento.*#(\d+)/)
    if (md) {
      return parseInt(md[1])
    }
  },

  sprintf(...args) { return Extsprintf.sprintf(...args) },
  printf(...args)  { return Extsprintf.printf(...args)  },
  fprintf(...args) { return Extsprintf.fprintf(...args) },

  user_call_name(str) {
    this.__assert__(this.present_p(str), "this.present_p(str) in user_call_name")
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
