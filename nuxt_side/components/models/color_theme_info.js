import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

const SAMPLE_SFEN = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"

export class ColorThemeInfo extends ApplicationMemoryRecord {
  static field_label = "配色"
  static field_message = ""

  static get define() {
    return [
      { key: "is_color_theme_groovy_board_texture1",   name: "木目A (濃)",       },
      { key: "is_color_theme_groovy_board_texture2",   name: "木目B (濃)",       },
      { key: "is_color_theme_groovy_board_texture3",   name: "木目C (濃)",       },
      { key: "is_color_theme_groovy_board_texture4",   name: "木目D (薄)",       },
      { key: "is_color_theme_groovy_board_texture5",   name: "木目E (薄)",       },
      { key: "is_color_theme_groovy_board_texture6",   name: "木目F (薄)",       },
      { key: "is_color_theme_piyo",                    name: "ぴよ将棋風"  ,       },
      { key: "is_color_theme_club24",                  name: "新24" ,              },
      { key: "is_color_theme_wars_red",                name: "赤ウォーズ",         },
      { key: "is_color_theme_wars_blue",               name: "青ウォーズ",         },
      { key: "is_color_theme_radial_gradiention1",     name: "放射グラデA",        },
      { key: "is_color_theme_radial_gradiention2",     name: "放射グラデB",        },
      { key: "is_color_theme_radial_gradiention3",     name: "放射グラデC",        },
      { key: "is_color_theme_radial_gradiention4",     name: "放射グラデD",        },
      { key: "is_color_theme_gradiention1",            name: "グラデA",            },
      { key: "is_color_theme_gradiention2",            name: "グラデB",            },
      { key: "is_color_theme_gradiention3",            name: "グラデC",            },
      { key: "is_color_theme_gradiention4",            name: "グラデD",            },
      { key: "is_color_theme_plasma_blur1",            name: "プラズマA",          },
      { key: "is_color_theme_plasma_blur2",            name: "プラズマB",          },
      { key: "is_color_theme_plasma_blur3",            name: "プラズマC",          },
      { key: "is_color_theme_plasma_blur4",            name: "プラズマD",          },
      { key: "is_color_theme_kimetsu_red",             name: "赤鬼滅",             },
      { key: "is_color_theme_kimetsu_blue",            name: "青鬼滅",             },
      { key: "is_color_theme_style_editor_asahanada",  name: "浅縹 (あさはなだ)",  },
      { key: "is_color_theme_style_editor_asagi",      name: "浅葱 (新撰組の青)",  },
      { key: "is_color_theme_style_editor_usubudou",   name: "薄葡萄",             },
      { key: "is_color_theme_style_editor_koiai",      name: "濃藍",               },
      { key: "is_color_theme_style_editor_kuromidori", name: "黒緑",               },
      { key: "is_color_theme_style_editor_kurobeni",   name: "黒紅",               },
      { key: "is_color_theme_mario_sky",               name: "スーパーマリオの空", },
      { key: "is_color_theme_shogi_extend",            name: "共有将棋盤",         },
      { key: "is_color_theme_style_editor",            name: "スタイルエディタ",   },
      { key: "is_color_theme_brightness_grey",         name: "グレイスケール",     },
      { key: "is_color_theme_brightness_green",        name: "ぜんぶ緑",           },
      { key: "is_color_theme_brightness_orange",       name: "ぜんぶオレンジ",     },
      { key: "is_color_theme_brightness_matrix",       name: "マトリックス",       },
      { key: "is_color_theme_splatoon_stripe_red",     name: "赤スプラ",           },
      { key: "is_color_theme_splatoon_stripe_green",   name: "緑スプラ",           },
      { key: "is_color_theme_splatoon_stripe_purple",  name: "紫スプラ",           },
      { key: "is_color_theme_paper_shape",             name: "☖付き紙面風",        },
      { key: "is_color_theme_paper_simple",            name: "紙面風",             },
    ]
  }

  thumbnail_url(context) {
    const url_base = context.$config.MY_SITE_URL + "/share-board.png"
    const url = new URL(url_base)
    url.searchParams.set("body", SAMPLE_SFEN)
    url.searchParams.set("color_theme_key", this.key)
    url.searchParams.set("width", 1920 / 1)
    url.searchParams.set("height", 1080 / 1)
    url.searchParams.set("color_theme_cached", "true") // これを取ると実際に生成する
    return url.toString()
  }

  get introduction() {
    return this.name
  }
}
