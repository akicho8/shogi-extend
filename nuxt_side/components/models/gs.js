import _ from "lodash"
import dayjs from "dayjs"
import { HandleNameParser } from "./handle_name_parser.js"
import Autolinker from 'autolinker'
const strip_tags = require('striptags')
// const ModExtsprintf = require('extsprintf')
import { ScreenSizeDetector } from "./screen_size_detector.js"

import Extsprintf from 'extsprintf'

import { DotSfen } from "@/components/models/dot_sfen.js"

// vue_support.js の methods に追加する
export const Gs = {
  // Bulma のマクロの JS 版
  // +mobile 相当は this.screen_match_p("mobile") とする
  screen_match_p(type) {
    return ScreenSizeDetector.match_p(type)
  },

  dot_sfen_escape(...args)   { return DotSfen.escape(...args)   }, // SFENの " " を "." に変更
  dot_sfen_unescape(...args) { return DotSfen.unescape(...args) }, // SFENの "." を " " に変更

  // 一周してくれる賢い剰余
  // -1 % 3 => 2
  //  4 % 3 => 1
  ruby_like_modulo(v, n) {
    if (n === 0) {
      throw new Error("divided by 0")
    }
    v = v % n
    v = Math.trunc(v)
    if (v < 0) {
      v = n + v
    }
    return v + 0
  },

  // 使用例
  //  foo_next(sign) {
  //    this.foo_key = this.ary_cycle_at(this.FooInfo.values, this.foo_info.code + sign).key
  //  }
  ary_cycle_at(ary, index) {
    return ary[this.ruby_like_modulo(index, ary.length)]
  },

  // expect(Gs.ruby_like_each_slice_to_a(["a", "b", "c", "d"], 2)).toEqual([["a", "b"], ["c", "d"]])
  // expect(Gs.ruby_like_each_slice_to_a(["a", "b", "c"], 2)).toEqual([["a", "b"], ["c"]])
  // expect(() => Gs.ruby_like_each_slice_to_a(["a", "b"], 0)).toThrow()
  // expect(Gs.ruby_like_each_slice_to_a([], 2)).toEqual([])
  ruby_like_each_slice_to_a(ary, step) {
    if (step <= 0) {
      throw new Error("invalid slice size")
    }
    const new_ary = []
    for (let i = 0; i < ary.length; i += step) {
      new_ary.push(ary.slice(i, i + step))
    }
    return new_ary
  },

  // ary を破壊しない安全な reverse
  safe_reverse(ary) {
    return ary.slice().reverse()
  },

  // 文字列からハッシュコードに変換
  // これは単純なものでよい
  hash_number_from_str(str) {
    return _.sumBy([...str], e => e.codePointAt(0))
  },

  hankaku_format(str) {
    return str.replace(/[Ａ-Ｚａ-ｚ０-９]/g, s => String.fromCharCode(s.charCodeAt(0) - 0xFEE0))
  },

  short_inspect(value) { return JSON.stringify(value) },
  pretty_inspect(value) { return JSON.stringify(value, null, 4)   },
  // inspect(value)        { return JSON.stringify(value)            },
  pretty_print(value)   { console.log(this.pretty_inspect(value)) },
  // p(value)              { console.log(this.inspect(value))        },
  // a(value)              { alert(this.inspect(value))              },
  pretty_alert(value)   { alert(this.pretty_inspect(value))       },
  a(value)              { alert(this.pretty_inspect(value))       },

  ////////////////////////////////////////////////////////////////////////////////

  // lodash の _.isEmpty は不自然な挙動なので使うべからず
  blank_p(value) {
    return value === undefined || value === null ||
      (typeof value === "object" && Object.keys(value).length === 0) ||
      (typeof value === "string" && value.trim().length === 0)
  },

  present_p(value) {
    return !this.blank_p(value)
  },

  presence(value) {
    if (this.blank_p(value)) {
      return null
    }
    return value
  },

  ////////////////////////////////////////////////////////////////////////////////

  // 片方を1に正規化した比率
  //
  //  100 : 50 = x : 1
  //  50x = 100
  //  x = 100 / 50
  //  x = 2
  //  ↓
  //  a : b = x : 1
  //  bx = a
  //  x = a / b
  //
  math_wh_normalize_aspect_ratio(w, h) {
    w = w || 0
    h = h || 0
    if (w === 0 || h === 0) {
      return
    }
    if (w >= h) {
      w = w / h
      h = 1
    } else {
      h = h / w
      w = 1
    }
    return [w, h]
  },

  // 人間向け表記の比率
  // 片方を1にするのではなく 4:3 などと表示する
  // ただOGPは 40:21 になり 1.91:1 の方が人間向け表記としてよく使われている
  math_wh_gcd_aspect_ratio(w, h) {
    w = w || 0
    h = h || 0
    if (w === 0 || h === 0) {
      return
    }
    const v = this.math_gcd(w, h)
    w = w / v
    h = h / v
    return [w, h]
  },

  math_gcd(a, b) {
    if (b === 0) {
      return a
    }
    return this.math_gcd(b, a % b)
  },

  ////////////////////////////////////////////////////////////////////////////////

  rand(n) {
    return Math.floor(Math.random() * n)
  },

  // 整数で min..max の間の乱数
  // https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/Math/random
  rand_int_range(min, max) {
    min = Math.ceil(min)
    max = Math.floor(max)
    return Math.floor(Math.random() * (max - min + 1) + min)
  },

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

  ////////////////////////////////////////////////////////////////////////////////

  n_times_collect(n, block) {
    const ary = []
    for (let i = 0; i < n; i++) {
      ary.push(block(i))
    }
    return ary
  },

  n_times(n, block) {
    for (let i = 0; i < n; i++) {
      block(i)
    }
  },

  ////////////////////////////////////////////////////////////////////////////////

  even_p(v) {
    return (v % 2) === 0
  },

  odd_p(v) {
    return !this.even_p(v)
  },

  ////////////////////////////////////////////////////////////////////////////////

  time_format_human_hms(seconds) {
    let format = ""
    if (seconds < 60) {
      format = "s秒"
    } else if (seconds < 60 * 60) {
      format = "m分s秒"
    } else {
      format = "H時間m分"
    }
    return dayjs.unix(seconds).format(format)
  },

  //////////////////////////////////////////////////////////////////////////////// tag

  tags_wrap(str) {
    return _.compact((str ?? "").split(/[,\s]+/))
  },

  tags_append(tags, append_tags) {
    tags = this.tags_wrap(tags)
    append_tags = this.tags_wrap(append_tags)
    return _.uniq([...tags, ...append_tags])
  },

  tags_remove(tags, remove_tags) {
    tags = this.tags_wrap(tags)
    remove_tags = this.tags_wrap(remove_tags)
    return _.reject(tags, e => remove_tags.includes(e))
  },

  simple_format(str) {
    return str.replace(/\n/g, "<br>")
  },

  // str から現在の手数を推測する
  // https://www.kento-shogi.com/?branch=B%2A8b.9c8c.8b7c%2B.7b7c.5b8b%2B.8c7d.P%2A7e.7d6c.8b6b.6c5d.6b5b&branchFrom=120&moves=2g2f.3c3d.2f2e.2b3c.2h2f.8b2b.4i3h.3a4b.2f3f.2c2d.2e2d.2b2d.P%2A2g.5a6b.9g9f.9c9d.7i6h.6b7b.3i4h.7a8b.6i7i.8c8d.5i5h.8b8c.8h9g.7b8b.9g7e.6a7b.7e6f.4c4d.3f2f.P%2A2e.2f5f.4a5b.5f4f.4b4c.3g3f.5b6b.4h3g.6c6d.7g7f.1c1d.1g1f.6b6c.5h4h.7c7d.4h3i.8a7c.5g5f.2d2b.6h5g.2b4b.5f5e.5c5d.5e5d.4c5d.5g5f.P%2A5e.5f5e.5d5e.6f5e.S%2A4e.4f4e.4d4e.5e3c%2B.2a3c.B%2A5a.4b5b.5a3c%2B.5b5i%2B.3i2h.5i7i.N%2A5e.R%2A5i.S%2A3i.B%2A5g.S%2A4h.5g4h%2B.3g4h.5i6i%2B.5e6c%2B.7b6c.7f7e.N%2A5f.P%2A5i.5f4h%2B.3i4h.4e4f.7e7d.4f4g%2B.7d7c%2B.6c7c.3h4g.P%2A4f.4g4f.G%2A4i.P%2A7d.8c7d.N%2A8f.4i4h.8f7d.7i7d.P%2A7e.7d7e.B%2A8f.7e8f.8g8f.B%2A3i.2h1h.4h3h.R%2A5b.P%2A7b.S%2A7a.8b9c.N%2A8e.8d8e.3c6f.N%2A8d.6f3i.3h3i.B%2A8b.9c8c.8b7c%2B.7b7c.G%2A8b.8c7d.P%2A7e.7d7e.5b5e%2B.N%2A6e.P%2A7f.8d7f.G%2A6f.7e8f.6f7f.8f8g#118
  // のURLから変換するときは現在局面 118 に合わせておきたい
  turn_guess(str) {
    const md = str.match(/http.*kento.*#(\d+)/)
    if (md) {
      return parseInt(md[1])
    }
  },

  // strip_tags(html)
  // strip_tags(html, '<strong>')
  // strip_tags(html, ['a'])
  // strip_tags(html, [], '\n')
  strip_tags(...args) {
    return strip_tags(...args)
  },

  sprintf(...args) { return Extsprintf.sprintf(...args) },
  printf(...args)  { return Extsprintf.printf(...args)  },
  fprintf(...args) { return Extsprintf.fprintf(...args) },

  user_call_name(str) {
    if (this.development_p) {
      this.__assert__(this.present_p(str), "this.present_p(str)")
    }
    return HandleNameParser.call_name(str)
  },

  // {a: 1, b: null, c:undefined, d: ""} => {a: 1, d: ""}
  hash_compact_if_null(hash) {
    return _.reduce(hash, (a, val, key) => {
      if (val == null) {
      } else {
        a[key] = val
      }
      return a
    }, {})
  },

  // {a: 1, b: null, c:undefined, d: ""} => {a: 1}
  hash_compact_if_blank(hash) {
    return _.reduce(hash, (a, val, key) => {
      if (val == null || val === "") {
      } else {
        a[key] = val
      }
      return a
    }, {})
  },

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

  hira_to_kata(str) {
    return str.replace(/[\u3041-\u3096]/g, ch => String.fromCharCode(ch.charCodeAt(0) + 0x60))
  },

  kata_to_hira(str) {
    return str.replace(/[\u30A1-\u30FA]/g, ch => String.fromCharCode(ch.charCodeAt(0) - 0x60))
  },

  // ../../../node_modules/autolinker/README.md
  // newWindow: true で target="_blank" になる
  auto_link(str, options = {}) {
    return Autolinker.link(str, {newWindow: true, truncate: 30, mention: "twitter", ...options})
  },

  // string_truncate("hello", {length: 20})
  string_truncate(str, options = {}) {
    return _.truncate(str, {omission: "...", length: 80, ...options})
  },

  defval(v, default_value) {
    if (v == null) {
      return default_value
    } else {
      return v
    }
  },

  // list 内のインデックス from の要素を to に移動
  // https://qiita.com/nowayoutbut/items/991515b32805e21f8892
  ary_move(list, from, to) {
    const n = list.length
    list = [...list]
    to = this.ruby_like_modulo(to, n)
    if (from === to || from > n - 1 || to > n - 1) {
      return list
    }
    const v = list[from]
    const tail = list.slice(from + 1)
    list.splice(from)
    Array.prototype.push.apply(list, tail)
    list.splice(to, 0, v)
    return list
  },

  // str_to_keywords("　,　a　,b,") // => ["a", "b"]
  // str_to_keywords(",")           // => []
  // str_to_keywords("")            // => []
  str_to_keywords(str) {
    str = str ?? ""
    str = str.replace(/\p{blank}+/g, " ") // 全角スペース → 半角スペース
    str = str.replace(/[\s,]+/g, " ")     // セパレータを半角スペースで統一
    str = _.trim(str)                     // 左右のスペースを除去
    if (str.length >= 1) {
      return _.uniq(str.split(/\s+/))
    } else {
      return []
    }
  },

  // keywords_str_toggle("a b", "c")   //=> "a b c"
  // keywords_str_toggle("a b c", "c") //=> "a b"
  keywords_str_toggle(keywords_str, str) {
    let keywords = this.str_to_keywords(keywords_str)
    if (keywords.includes(str)) {
      _.pull(keywords, str)
    } else {
      keywords.push(str)
    }
    return keywords.join(" ")
  },
}
