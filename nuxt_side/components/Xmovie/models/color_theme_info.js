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
      { separator: true },
      { key: "real_wood_theme1",              name: "木1",                media_name: null, type: "is-primary", message: null, },
      { key: "real_wood_theme2",              name: "木2",                media_name: null, type: "is-primary", message: null, },
      { key: "real_wood_theme3",              name: "木3",                media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "kimetsu_red_theme",             name: "鬼滅風 Violet Red",  media_name: null, type: "is-primary", message: null, },
      { key: "kimetsu_blue_theme",            name: "鬼滅風 Sky Blue",    media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "style_editor_asahanada_theme",  name: "浅縹",               media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_usubudou_theme",   name: "薄葡萄",             media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_koiai_theme",      name: "濃藍",               media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_kuromidori_theme", name: "黒緑",               media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_kurobeni_theme",   name: "黒紅",               media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "splatoon_red_black_theme",      name: "スプラトゥーン赤",   media_name: null, type: "is-primary", message: null, },
      { key: "splatoon_green_black_theme",    name: "スプラトゥーン緑",   media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "youtube_red_theme",             name: "Youtube の赤",       media_name: null, type: "is-primary", message: null, },
      { key: "mario_sky_theme",               name: "スーパーマリオの空", media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "shogi_extend_theme",            name: "共有将棋盤",         media_name: null, type: "is-primary", message: null, },
      { key: "style_editor_theme",            name: "スタイルエディタ",   media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "paper_simple_theme",            name: "紙面風",             media_name: null, type: "is-primary", message: null, },
      { key: "paper_shape_theme",             name: "紙面風 + 駒型",      media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "brightness_grey_theme",         name: "彩度なし",           media_name: null, type: "is-primary", message: null, },
      { key: "brightness_green_theme",        name: "色調固定 緑",        media_name: null, type: "is-primary", message: null, },
      { key: "brightness_orange_theme",       name: "色調固定 オレンジ",  media_name: null, type: "is-primary", message: null, },
      { key: "brightness_matrix_theme",       name: "マトリックス",       media_name: null, type: "is-primary", message: null, },
    ]
  }

  thumbnail_url(context) {
    const url_base = context.$config.MY_SITE_URL + "/share-board.png"
    const url = new URL(url_base)
    url.searchParams.set("body", SAMPLE_SFEN)
    url.searchParams.set("color_theme_key", this.key)
    // url.searchParams.set("width", 720)
    // url.searchParams.set("height", 540)
    url.searchParams.set("width", 1280)
    url.searchParams.set("height", 720)
    return url.toString()
  }
}
