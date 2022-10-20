import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CcInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "ck_on",            name: "設置",         },
      { key: "ck_off",           name: "破棄",         },
      { key: "ck_start",         name: "開始",         },
      { key: "ck_pause",         name: "一時停止",     },
      { key: "ck_resume",        name: "再開",         },
      { key: "ck_stop",          name: "停止",         },
      { key: "ck_timeout",       name: "時間切れ",     },
      { key: "ck_manual_sync",   name: "同期手動実行", },
      { key: "ck_bug",           name: "不具合再現",   },
    ]
  }
}
