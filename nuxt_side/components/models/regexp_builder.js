export const RegexpBuilder = {
  string(types) {
    return types.map(e => this.__PART[e]).join("")
  },

  build(types) {
    // Unicodeフラグ 'u' を追加することで \p{...} が動作するようになる
    return new RegExp(`^[${this.string(types)}]+$`, 'u')
  },

  // private
  __PART: {
    half_width_alpha:             'a-zA-Z',
    half_width_number:            '0-9',
    full_width_kanji:             '\\p{Script=Han}',      // "々" を含む
    full_width_hiragana:          '\\p{Script=Hiragana}',
    // 記号類を個別に定義
    full_width_hyphen_wave:       'ー〜',
    full_width_kanji_number:      '一二三四五六七八九十',
    half_width_hyphen_underscore: '_\\-',
  },
}
