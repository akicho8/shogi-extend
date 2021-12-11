import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ColumnInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "id",               name: "ID",       visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "attack_tag_list",  name: "戦型",     visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "defense_tag_list", name: "囲い",     visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "final_key",        name: "結果",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "turn_max",         name: "手数",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "critical_turn",    name: "開戦",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "outbreak_turn",    name: "中盤",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "grade_diff",       name: "力差",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "rule_key",         name: "種類",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "preset_key",       name: "手合",     visible: false,  operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "battled_at",       name: "日時",     visible: true,   operation_p: false, available_env: { development: true, staging: true,  production: true, }, },
      { key: "piyo_shogi",       name: "ぴよ将棋", visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "kento",            name: "KENTO",    visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "kif_copy",         name: "コピー",   visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
      { key: "show",             name: "詳細",     visible: true,   operation_p: true,  available_env: { development: true, staging: true,  production: true, }, },
    ]
  }

  available_p(context) {
    return this.available_env[context.$config.STAGE]
  }
}
