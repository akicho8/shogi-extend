import _ from "lodash"

// vue_support.js の methods に追加する
export const AnySupport = {
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

  // 文字列からハッシュコードに変換
  // これは単純なものでよい
  hash_number_from_str(str) {
    return _.sumBy([...str], e => e.codePointAt(0))
  },

  hankaku_format(str) {
    return str.replace(/[Ａ-Ｚａ-ｚ０-９]/g, s => String.fromCharCode(s.charCodeAt(0) - 0xFEE0))
  },
}
