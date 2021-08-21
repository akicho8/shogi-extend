import MemoryRecord from 'js-memory-record'

export class AudioThemeInfo extends MemoryRecord {
  static get field_label() {
    return "音"
  }

  static get field_message() {
    return ""
  }

  static get define() {
    return [
      { key: "audio_theme_none",                name: "なし",                             type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: null,                                                                              },
      { key: "audio_theme_positive_think_only", name: "前向きピアノ",                     type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/positive_think.m4a'),  },
      { key: "audio_theme_breakbeat_only",      name: "ブレイクビート",                   type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/breakbeat_long.m4a'),  },
      { key: "audio_theme_headspin_only",       name: "ヘッドスピン",                     type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/headspin_long.m4a'),   },
      { key: "audio_theme_dance",               name: "ヘッドスピンからのブレイクビート", type: "is-primary", environment: ["development", "staging", "production"], message: null, sample_m4a: null,                                                                              },
      { key: "audio_theme_war",                 name: "戦争系",                           type: "is-primary", environment: ["development", "staging",             ], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/strategy.m4a'),        },
      { key: "audio_theme_stg",                 name: "STG系(いまいち)",                  type: "is-primary", environment: ["development", "staging",             ], message: null, sample_m4a: require('../../../../../bioshogi/lib/bioshogi/assets/audios/stg_like_type1a.m4a'), },
    ]
  }
}
