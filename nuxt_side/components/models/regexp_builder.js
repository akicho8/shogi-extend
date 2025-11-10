export const RegexpBuilder = {
  string(types) {
    return types.map(e => this.__PART[e]).join("")
  },

  build(types) {
    return new RegExp(`^[${this.string(types)}]+$`)
  },

  // private

  __PART: {
    half_width_alpha:             'a-zA-Z',               // 半角英字
    half_width_number:            '0-9',                  // 半角数字
    full_width_kanji:             '\u4E00-\u9FFF',        // 全角漢字
    full_width_hiragana:          '\u3040-\u309F',        // 全角ひらがな
    full_width_hyphen_wave:       'ー〜',                 // 全角カナの伸ばし棒 と カナでもひらがなでもない波線
    full_width_kanji_number:      '一二三四五六七八九十', // 漢数字
    half_width_hyphen_underscore: '_\\-',                 // Hyhen Underscore
  },
}
