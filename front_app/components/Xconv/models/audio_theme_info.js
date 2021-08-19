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
      { key: "audio_theme_none",                name: "なし",               type: "is-primary", environment: ["development", "staging", "production"], message: null, },
      { key: "audio_theme_positive_think_only", name: "前向きピアノ",       type: "is-primary", environment: ["development", "staging", "production"], message: null, },
      { key: "audio_theme_breakbeat_only",      name: "ブレイクビート",     type: "is-primary", environment: ["development", "staging", "production"], message: null, },
      { key: "audio_theme_headspin_only",       name: "ヘッドスピン",       type: "is-primary", environment: ["development", "staging", "production"], message: null, },
      { key: "audio_theme_dance",               name: "ダンスハイブリッド", type: "is-primary", environment: ["development", "staging", "production"], message: null, },
      { key: "audio_theme_war",                 name: "戦争系",             type: "is-primary", environment: ["development", "staging", "production"], message: null, },
      { key: "audio_theme_stg",                 name: "STG系(いまいち)",    type: "is-primary", environment: ["development", "staging", "production"], message: null, },
    ]
  }
}
