import MemoryRecord from 'js-memory-record'

const SAMPLE_SFEN = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"

export class ColorThemeInfo extends MemoryRecord {
  static get field_label() {
    return "色"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { separator: true },
      { key: "color_theme_is_real_wood1",              name: "リアル盤1",           media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_real_wood2",              name: "リアル盤2",           media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_real_wood3",              name: "リアル盤3",           media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_cg_wood1",                name: "CGの盤1",             media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_cg_wood2",                name: "CGの盤2",             media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_cg_wood3",                name: "CGの盤3",             media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_cg_wood4",                name: "CGの盤3",             media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_metal1",                  name: "メタル盤",            media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_gradiention1",            name: "グラデーション1",     media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_gradiention2",            name: "グラデーション2",     media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_gradiention3",            name: "グラデーション3",     media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_gradiention4",            name: "グラデーション4",     media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_kimetsu_red",             name: "鬼滅風 Violet Red",   media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_kimetsu_blue",            name: "鬼滅風 Sky Blue",     media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_style_editor_asahanada",  name: "浅縹 (あさはなだ)",   media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_style_editor_usubudou",   name: "薄葡萄 (うすぶどう)", media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_style_editor_koiai",      name: "濃藍",                media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_style_editor_kuromidori", name: "黒緑",                media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_style_editor_kurobeni",   name: "黒紅",                media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_splatoon_red_black",      name: "スプラトゥーン赤",    media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_splatoon_green_black",    name: "スプラトゥーン緑",    media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_mario_sky",               name: "スーパーマリオの空",  media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_shogi_extend",            name: "共有将棋盤",          media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_style_editor",            name: "スタイルエディタ",    media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_paper_simple",            name: "紙面風",              media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_paper_shape",             name: "紙面風 + 駒型",       media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "color_theme_is_brightness_grey",         name: "彩度なし",            media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_brightness_green",        name: "色調固定 緑",         media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_brightness_orange",       name: "色調固定 オレンジ",   media_name: null, type: "is-primary", message: null, },
      { key: "color_theme_is_brightness_matrix",       name: "マトリックス",        media_name: null, type: "is-primary", message: null, },
    ]
  }

  thumbnail_url(context) {
    const url_base = context.$config.MY_SITE_URL + "/share-board.png"
    const url = new URL(url_base)
    url.searchParams.set("body", SAMPLE_SFEN)
    url.searchParams.set("color_theme_key", this.key)
    // url.searchParams.set("width", 720)
    // url.searchParams.set("height", 540)
    url.searchParams.set("width", 1280 / 2)
    url.searchParams.set("height", 720 / 2)
    return url.toString()
  }
}
