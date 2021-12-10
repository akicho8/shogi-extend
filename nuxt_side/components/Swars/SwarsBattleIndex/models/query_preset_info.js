import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class QueryPresetInfo extends ApplicationMemoryRecord {
  static field_label = "検索プリセット"

  static get define() {
    return [
      { key: "query_preset_judge_win",  name: "勝ち",            query: "judge:win",                 available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "負け",            query: "judge:lose",                available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "150手以上で勝ち", query: "turn_max:>=150 judge:win",  available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "150手以上で負け", query: "turn_max:>=150 judge:lose", available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "50手以下で勝ち",  query: "turn_max:<=50 judge:win",   available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "50手以下で負け",  query: "turn_max:<=50 judge:lose",  available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "指導対局",        query: "vs-grade:十段",             available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "10分",            query: "rule:10分",                 available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "3分",             query: "rule:3分",                  available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "10秒",            query: "rule:10秒",                 available_env: { development: true, staging: true, production: true, }, },
      { key: null,                      name: "すべて",          query: "",                          available_env: { development: true, staging: true, production: true, }, },
    ]
  }

  available_p(context) {
    return this.available_env[context.$config.STAGE]
  }
}
