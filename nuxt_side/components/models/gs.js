import _ from "lodash"
import dayjs from "dayjs"

// vue_support.js の methods に追加する
export const Gs = {
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
}
