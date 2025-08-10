import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ColumnInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "user_key_left",        name: "自分の名前",       visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "user_key_right",       name: "相手の名前",       visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "membership_left",      name: "自分",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "membership_right",     name: "相手",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "style_key",            name: "棋風",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "judge_key",            name: "勝敗",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "location_key",         name: "先後",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "final_key",            name: "結末",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "turn_max",             name: "手数",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "critical_turn",        name: "開戦",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "outbreak_turn",        name: "中盤",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "grade_diff",           name: "力差",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "rule_key",             name: "持ち時間",         visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "xmode_key",            name: "モード",           visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "imode_key",            name: "開始モード",       visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "preset_key",           name: "手合",             visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "battled_at",           name: "日時",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },

      { key: "piyo_shogi",           name: "ぴよ将棋",         visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "kento",                name: "KENTO",            visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "kif_copy",             name: "コピー (KIF)",     visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "ki2_copy",             name: "コピー (KI2)",     visible: false,  operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "kif_save_as_utf8",     name: "保存 (UTF-8)",     visible: false,  operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "kif_save_as_shiftjis", name: "保存 (Shift_JIS)", visible: false,  operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "show",                 name: "詳細",             visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },

      { key: "id",                   name: "ID",               visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "badge",                name: "アイコン",         visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "attack_tag_list",      name: "戦法",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "defense_tag_list",     name: "囲い",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "technique_tag_list",   name: "手筋",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "note_tag_list",        name: "備考",             visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },

      { key: "mobile_card",          name: "スマホなら縦並び", visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "tablet_header",        name: "表の見出し(PC)",   visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
    ]
  }

  static get operation_records() {
    return this.values.filter(e => e.operation_p)
  }

  available_p(context) {
    return this.available_env[context.$config.STAGE]
  }
}
