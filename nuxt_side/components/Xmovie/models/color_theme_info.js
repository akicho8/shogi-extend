import MemoryRecord from 'js-memory-record'

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
      { key: "paper_simple_theme",      name: "白",                media_name: null, type: "is-primary", message: null, },
      { key: "paper_shape_theme",       name: "白 + 六角形",       media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "brightness_grey_theme",   name: "グレースケール",    media_name: null, type: "is-primary", message: null, },
      { key: "brightness_matrix_theme", name: "マトリックス",      media_name: null, type: "is-primary", message: null, },
      { key: "brightness_green_theme",  name: "緑",                media_name: null, type: "is-primary", message: null, },
      { key: "brightness_orange_theme", name: "オレンジ",          media_name: null, type: "is-primary", message: null, },
      { separator: true },
      { key: "kimetsu_red_theme",       name: "鬼滅風 Violet Red", media_name: null, type: "is-primary", message: null, },
      { key: "kimetsu_blue_theme",      name: "鬼滅風 Skey Blue",  media_name: null, type: "is-primary", message: null, },
    ]
  }

  thumbnail_url(context) {
    const url_base = context.$config.MY_SITE_URL + "/share-board.png"
    const url = new URL(url_base)
    url.searchParams.set("body", "position sfen lnsgkgsnl/1r7/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 moves 7a6b 7g7f 5c5d 2g2f 5a4b 2f2e 4b3b 2e2d 2c2d 2h2d 6b5c 2d2f P*2c 3i4h 8c8d 7i7h 8d8e 8h7g 4a4b 5g5f 6a5b 6g6f 7c7d 7g6h 5c6d 7h6g 5b5c 6i7h 9c9d 9g9f 5c4d 6f6e 6d7c 4h5g 8b6b 8i7g 6b8b 5g6f 1c1d 1g1f 9d9e 9f9e 8e8f 8g8f 9a9e P*9g 9e9g 9i9g P*9f 7g8e 9f9g+ 8e7c+ 8a7c P*9d 8b9b S*8c 9b9a 2f2h P*8g 6h4f 5d5e 6f5e 4d4e 4f5g 7c6e 5g8d N*3e L*2g 3e2g+ 2h2g 8g8h+ 7h6h 9g8g 5e6f 8h7h 6g7h 8g7h 6h7h L*6d P*6g 4e5f P*5h P*5g 2g2f L*5c 6f6e 6d6e 5i6h 5g5h+ 4i5h P*5g 5h4h S*8i N*7i P*8g 7h8g S*7h N*6f 9a8a 9d9c+ 7h8g+ 7i8g 8a8c 9c8c G*7h 6h5i S*5h")
    url.searchParams.set("color_theme_key", this.key)
    url.searchParams.set("width", 720)
    url.searchParams.set("height", 540)
    return url.toString()
  }
}
