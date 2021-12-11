import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"
import { MigigyokuInfo } from "@/components/models/migigyoku_info.js"

export class QueryPresetInfo extends ApplicationMemoryRecord {
  static field_label = "検索プリセット"

  static get define() {
    return [
      { key: null,                      name: "大金星",          query: "力差:>=2 judge:win",          available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "金星",            query: "力差:==1 judge:win",          available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "vs 上手",         query: "力差:>=1",                    available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "勝ち 150手以上",  query: "手数:>=150 judge:win",        available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "勝ち 50手以下",   query: "手数:<=50 judge:win",         available_env: { development: true, staging: true, production: true, }, },
      { key: "query_preset_judge_win",  name: "勝ち",            query: "judge:win",                   available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "大黒星",          query: "力差:<=-2 judge:lose",        available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "黒星",            query: "力差:==-1 judge:lose",        available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "vs 下手",         query: "力差:<=-1",                   available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "負け 150手以上",  query: "手数:>=150 judge:lose",       available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "負け 50手以下",   query: "手数:<=50 judge:lose",        available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "負け",            query: "judge:lose",                  available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "10分",            query: "rule:10分",                   available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "3分",             query: "rule:3分",                    available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "10秒",            query: "rule:10秒",                   available_env: { development: true, staging: true, production: true, }, },

      { key: null,                      name: "右玉",            query: `or-tag:${this.migi_list}`,    available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "vs 右玉",         query: `vs-or-tag:${this.migi_list}`, available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "指導対局",        query: "vs-grade:十段",               available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "すべて",          query: "",                            available_env: { development: true, staging: true, production: true, }, },
    ]
  }

  static get migi_list() {
    return MigigyokuInfo.values.map(e => e.name).join(",")
  }

  available_p(context) {
    return this.available_env[context.$config.STAGE]
  }
}
