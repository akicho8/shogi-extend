import MemoryRecord from 'js-memory-record'

export class AudioThemeInfo extends MemoryRecord {
  static get field_label() {
    return "BGM"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      // ../../../../../bioshogi/lib/bioshogi/audio_theme_info.rb
      { key: "audio_theme_custom",              name: "カスタム",                         type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: null, },
      { separator: true },
      { key: "audio_theme_none",                name: "なし",                             type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: null,                                                                              },
      { key: "audio_theme_positive_think_only", name: "前向きピアノ",                     type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/positive_think.m4a'),  },
      { key: "audio_theme_headspin_only",       name: "ヘッドスピン",                     type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a'),   },
      { key: "audio_theme_breakbeat_only",      name: "ブレイクビート",                   type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/breakbeat_long.m4a'),  },
      { key: "audio_theme_dance",               name: "ヘッドスピンからのブレイクビート", type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: null,                                                                              },
      { key: "audio_theme_war",                 name: "戦争系",                           type: "is-primary", environment: ["development", "staging",             ], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/strategy.m4a'),        },
      { key: "audio_theme_stg",                 name: "STG系(いまいち)",                  type: "is-primary", environment: ["development", "staging",             ], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/stg_like_type1a.m4a'), },

      { key: "audio_theme_nc97718",             name: "てってってー",                    type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc97718.m4a'), url: "https://commons.nicovideo.jp/material/nc97718",   author:  "ターリー◆dtTARy/mt2", desc: "",                                          },
      { key: "audio_theme_nc55257",             name: "３分クッキングのテーマソング",    type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc55257.m4a'), url: "https://commons.nicovideo.jp/material/nc55257",   author: "ジェルバ",             desc: "",                                          },
      { key: "audio_theme_nc770",               name: "優しい風",                        type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc770.m4a'), url: "https://commons.nicovideo.jp/material/nc770",       author: "McCoy",                desc: "",                                          },
      { key: "audio_theme_nc768",               name: "マーチ・マーチ",                  type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc768.m4a'), url: "https://commons.nicovideo.jp/material/nc768",       author: "McCoy",                desc: "",                                          },
      { key: "audio_theme_nc43122",             name: "夜間航海",                        type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc43122.m4a'), url: "https://commons.nicovideo.jp/material/nc43122",   author: "McCoy",                desc: "",                                          },
      { key: "audio_theme_nc799",               name: "夏の夜に-Piano solo-",            type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc799.m4a'), url: "https://commons.nicovideo.jp/material/nc799",       author: "McCoy",                desc: "",                                          },
      { key: "audio_theme_nc35943",             name: "昼下がり",                        type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc35943.m4a'), url: "https://commons.nicovideo.jp/material/nc35943",   author: "369",                  desc: "loop",                                      },
      { key: "audio_theme_nc3366",              name: "はてな",                          type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc3366.m4a'), url: "https://commons.nicovideo.jp/material/nc3366",     author: "しましまP @shimakid",  desc: "",                                          },
      { key: "audio_theme_nc10812",             name: "BGM026 Jazz",                     type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc10812.m4a'), url: "https://commons.nicovideo.jp/material/nc10812",   author: "sanche",               desc: "ニコ生の作品以外では要連絡",                },
      { key: "audio_theme_nc105702",            name: "【ゆるい日常BGM】ぐだぐだな感じ", type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc105702.m4a'), url: "https://commons.nicovideo.jp/material/nc105702", author: "yuki",                 desc: "",                                          },
      { key: "audio_theme_nc107860",            name: "Shall we meet？",                 type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/nc107860.m4a'), url: "https://commons.nicovideo.jp/material/nc107860", author: "MATSU",                desc: "loop",                                      },
      { key: "audio_theme_ds7615",              name: "Winner",                          type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/ds7615.m4a'), url: "https://dova-s.jp/bgm/play7615.html",              author: "FLASH☆BEAT",          desc: "loop",                                      },
      { key: "audio_theme_ds4712",              name: "昼下がり気分",                    type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/ds4712.m4a'), url: "https://dova-s.jp/bgm/play4712.html",              author: "KK",                   desc: "作者の紹介でYoutube動画に適しているとある", },
    ]
  }
}
