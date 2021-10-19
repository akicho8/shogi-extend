import MemoryRecord from 'js-memory-record'

const SAMPLE_SFEN = "position sfen l+n1g1g1n+l/1ks2r1+r1/1pppp1bpp/p2+b+sp+p2/9/P1P1+SP1PP/1+P+BPP1P2/1BK1GR1+R1/+L+NSG3NL b R2B3G4S5N11L99Pr2b3g4s5n11l99p 1"

export class ColorThemeInfo extends MemoryRecord {
  static field_label = "配色"
  static field_message = ""

  static get define() {
    return [
      // // { key: "is_color_theme_groovy_board_texture1",  name: "木目盤1",             },
      // // { key: "is_color_theme_groovy_board_texture2",  name: "木目盤2",             },
      // { key: "is_color_theme_groovy_board_texture3",  name: "木目盤3",             },
      // // { key: "is_color_theme_groovy_board_texture4",  name: "木目盤4",             },
      // // { key: "is_color_theme_groovy_board_texture5",  name: "木目盤5",             },
      // // { key: "is_color_theme_groovy_board_texture6",  name: "木目盤6",             },
      // // { key: "is_color_theme_groovy_board_texture7",  name: "木目盤7",             },
      // { key: "is_color_theme_groovy_board_texture1",  name: "木目盤8",             },
      // // { key: "is_color_theme_groovy_board_texture9",  name: "木目盤9",             },
      // // { key: "is_color_theme_groovy_board_texture10",  name: "木目盤10",            },
      // // { key: "is_color_theme_groovy_board_texture11",  name: "木目盤11",            },
      // // { key: "is_color_theme_groovy_board_texture12",  name: "木目盤12",            },
      // { key: "is_color_theme_groovy_board_texture13",  name: "木目盤13",            },
      // // { key: "is_color_theme_groovy_board_texture14",  name: "木目盤14",            },
      // // { key: "is_color_theme_groovy_board_texture15",  name: "木目盤15",            },
      // { key: "is_color_theme_metal1",                  name: "メタル盤",            },
      // { key: "is_color_theme_wars",                    name: "ウォーズ(?)",         },
      // { key: "is_color_theme_club24",                  name: "24(?)" ,              },
      // { key: "is_color_theme_gradiention1",            name: "グラデーション1",     },
      // { key: "is_color_theme_gradiention2",            name: "グラデーション2",     },
      // { key: "is_color_theme_gradiention3",            name: "グラデーション3",     },
      // { key: "is_color_theme_gradiention4",            name: "グラデーション4",     },
      // // { key: "is_color_theme_gradiention5",         name: "グラデーション5",     },
      // // { key: "is_color_theme_gradiention6",         name: "グラデーション6",     },
      // { key: "is_color_theme_plasma_blur1",            name: "プラズマブラー1",     },
      // { key: "is_color_theme_plasma_blur2",            name: "プラズマブラー2",     },
      // { key: "is_color_theme_plasma_blur3",            name: "プラズマブラー3",     },
      // { key: "is_color_theme_plasma_blur4",            name: "プラズマブラー4",     },
      // // { key: "is_color_theme_plasma_blur5",         name: "プラズマブラー5",     },
      // // { key: "is_color_theme_plasma_blur6",         name: "プラズマブラー6",     },
      // { key: "is_color_theme_radial_gradiention1",     name: "放射グラデーション1", },
      // { key: "is_color_theme_radial_gradiention2",     name: "放射グラデーション2", },
      // { key: "is_color_theme_radial_gradiention3",     name: "放射グラデーション3", },
      // { key: "is_color_theme_radial_gradiention4",     name: "放射グラデーション4", },
      // // { key: "is_color_theme_radial_gradiention5",  name: "放射グラデーション5", },
      // // { key: "is_color_theme_radial_gradiention6",  name: "放射グラデーション6", },
      // { key: "is_color_theme_kimetsu_red",             name: "鬼滅風 Violet Red",   },
      // { key: "is_color_theme_kimetsu_blue",            name: "鬼滅風 Sky Blue",     },
      // { key: "is_color_theme_style_editor_asahanada",  name: "浅縹 (あさはなだ)",   },
      // { key: "is_color_theme_style_editor_asagi",      name: "浅葱 (新撰組の青)",   },
      // { key: "is_color_theme_style_editor_usubudou",   name: "薄葡萄 (うすぶどう)", },
      // { key: "is_color_theme_style_editor_koiai",      name: "濃藍",                },
      // { key: "is_color_theme_style_editor_kuromidori", name: "黒緑",                },
      // { key: "is_color_theme_style_editor_kurobeni",   name: "黒紅",                },
      // { key: "is_color_theme_splatoon_stripe_red",     name: "スプラトゥーン赤",    },
      // { key: "is_color_theme_splatoon_stripe_green",   name: "スプラトゥーン緑",    },
      // { key: "is_color_theme_splatoon_stripe_purple",  name: "スプラトゥーン紫",    },
      // { key: "is_color_theme_mario_sky",               name: "スーパーマリオの空",  },
      // { key: "is_color_theme_shogi_extend",            name: "共有将棋盤",          },
      // { key: "is_color_theme_style_editor",            name: "スタイルエディタ",    },
      // { key: "is_color_theme_paper_simple",            name: "紙面風",              },
      // { key: "is_color_theme_paper_shape",             name: "紙面風 + 駒型",       },
      // { key: "is_color_theme_brightness_grey",         name: "彩度なし",            },
      // { key: "is_color_theme_brightness_green",        name: "色調固定 緑",         },
      // { key: "is_color_theme_brightness_orange",       name: "色調固定 オレンジ",   },
      // { key: "is_color_theme_brightness_matrix",       name: "マトリックス",        },
      // // { key: "is_color_theme_real_wood1",              name: "リアル盤1(没)",       },
      // // { key: "is_color_theme_real_wood2",              name: "リアル盤2(没)",       },
      // // { key: "is_color_theme_real_wood3",              name: "リアル盤3(没)",       },
      // // { key: "is_color_theme_cg_wood1",                name: "CGの盤1(没)",         },
      // // { key: "is_color_theme_cg_wood2",                name: "CGの盤2(没)",         },
      // // { key: "is_color_theme_cg_wood3",                name: "CGの盤3(没)",         },
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

  get introduction() {
    return this.name
  }
}
