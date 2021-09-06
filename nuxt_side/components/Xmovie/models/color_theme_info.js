import MemoryRecord from 'js-memory-record'

const SAMPLE_SFEN = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"

export class ColorThemeInfo extends MemoryRecord {
  static get field_label() {
    return "配色"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "shogi_extend_theme",      name: "普通",              media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_theme",      name: "スタイルエディタ1", media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_blue_theme", name: "スタイルエディタ2", media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_pink_theme", name: "スタイルエディタ3", media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "real_wood_theme",         name: "木",                media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "paper_simple_theme",      name: "紙面風",            media_name: null, type: "is-primary", message: null, },
      { key: "paper_shape_theme",       name: "紙面風 + 駒型",     media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "kimetsu_red_theme",       name: "鬼滅風 Violet Red", media_name: null, type: "is-primary", message: null, },
      { key: "kimetsu_blue_theme",      name: "鬼滅風 Sky Blue",   media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "brightness_grey_theme",   name: "グレースケール",    media_name: null, type: "is-primary", message: null, },
      { key: "brightness_green_theme",  name: "緑",                media_name: null, type: "is-primary", message: null, },
      { key: "brightness_orange_theme", name: "オレンジ",          media_name: null, type: "is-primary", message: null, },
      { key: "brightness_matrix_theme", name: "マトリックス",      media_name: null, type: "is-primary", message: null, },
    ]
  }

  thumbnail_url(context) {
    const url_base = context.$config.MY_SITE_URL + "/share-board.png"
    const url = new URL(url_base)
    url.searchParams.set("body", SAMPLE_SFEN)
    url.searchParams.set("color_theme_key", this.key)
    url.searchParams.set("width", 720)
    url.searchParams.set("height", 540)
    return url.toString()
  }
}
