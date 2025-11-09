export const RegexpBuilder = {
  string(types) {
    return types.map(e => this.__PART[e]).join("")
  },

  build(types) {
    return new RegExp(`^[${this.string(types)}]+$`)
  },

  // private

  __PART: {
    half_width_alpha:    'a-zA-Z',                     // 半角英字
    half_width_number:   '0-9',                        // 半角数字
    half_width_kana:     '\uFF61-\uFF9F',              // 半角カタカナ
    full_width_alpha:    '\uFF21-\uFF3A\uFF41-\uFF5A', // 全角英字
    full_width_number:   '\uFF10-\uFF19',              // 全角数字
    full_width_kana:     '\u30A0-\u30FF',              // 全角カタカナ
    full_width_kanji:    '\u4E00-\u9FFF',              // 全角漢字
    full_width_hiragana: '\u3040-\u309F',              // 全角ひらがな
    kansuuji:            '一二三四五六七八九十',       // 漢数字
    half_width_hyphen_underscore: '_\\-',              // Hyhen Underscore
  },
}
