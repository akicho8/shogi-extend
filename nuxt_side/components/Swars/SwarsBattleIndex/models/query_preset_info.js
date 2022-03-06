import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { MigigyokuInfo } from "@/components/models/migigyoku_info.js"

export class QueryPresetInfo extends ApplicationMemoryRecord {
  static field_label = "プリセット"

  static get define() {
    return [
      { key: null,                      name: "金星",             query: "力差:>=1 勝敗:勝ち 手数:>=14",  available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "大金星",           query: "力差:>=2 勝敗:勝ち 手数:>=14",  available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "vs 格上",          query: "力差:>=1",                      available_env: { development: true, staging: true, production: true, }, },
      { key: "query_preset_judge_win",  name: "勝ち",             query: "勝敗:勝ち",                     available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "あっさり勝ち",     query: "手数:<=70 勝敗:勝ち",           available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "相手が切断",       query: "勝敗:勝ち 結末:切断 手数:>=14", available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "黒星",             query: "力差:<=-1 勝敗:負け 手数:>=14", available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "大黒星",           query: "力差:<=-2 勝敗:負け 手数:>=14", available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "vs 格下",          query: "力差:<=-1",                     available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "負け",             query: "勝敗:負け",                     available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "あっさり負け",     query: "手数:<=70 勝敗:負け",           available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "切れ負け",         query: "勝敗:負け 結末:時間切れ",       available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "自分が切断",       query: "勝敗:負け 結末:切断 手数:>=14", available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "急戦",             query: "中盤:<=39",                     available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "持久戦",           query: "中盤:>=50",                     available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "長手数",           query: "手数:>=150",                    available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "短手数",           query: "手数:<=70",                     available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "居飛車",           query: `tag:居飛車`,                    available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "振り飛車",         query: `tag:振り飛車`,                  available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "対居飛車",         query: `vs-tag:居飛車`,                 available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "対振り",           query: `vs-tag:振り飛車`,               available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "相居飛車",         query: `tag:居飛車 vs-tag:居飛車`,      available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "相振り",           query: `tag:振り飛車 vs-tag:振り飛車`,  available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "右玉",             query: `or-tag:${this.migi_list}`,      available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "対右玉",           query: `vs-or-tag:${this.migi_list}`,   available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "指導対局",         query: "vs-grade:十段",                 available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "10分",             query: "種類:10分",                     available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "3分",              query: "種類:3分",                      available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "10秒",             query: "種類:10秒",                     available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "すべて",           query: "",                              available_env: { development: true, staging: true, production: true, }, },
    ]
  }

  static get migi_list() {
    return MigigyokuInfo.values.map(e => e.name).join(",")
  }

  available_p(context) {
    return this.available_env[context.$config.STAGE]
  }
}
