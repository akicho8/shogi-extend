import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CcInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "ck_on",            name: "設置",             with_url: false, toast_p: true,  with_talk: true,  },
      { key: "ck_off",           name: "破棄",             with_url: false, toast_p: true,  with_talk: true,  },
      { key: "ck_start",         name: "開始",             with_url: false, toast_p: null,  with_talk: null,  }, // 特別処理
      { key: "ck_pause",         name: "一時停止",         with_url: false, toast_p: true,  with_talk: true,  },
      { key: "ck_resume",        name: "再開",             with_url: false, toast_p: true,  with_talk: true,  },
      { key: "ck_stop",          name: "停止",             with_url: true,  toast_p: true,  with_talk: true,  },
      { key: "ck_silent_stop",   name: "停止",             with_url: true,  toast_p: true,  with_talk: false, },
      { key: "ck_timeout",       name: "時間切れ",         with_url: true,  toast_p: null,  with_talk: null,  }, // 特別処理
      { key: "ck_manual_sync",   name: "同期手動実行",     with_url: false, toast_p: true,  with_talk: true,  },
      { key: "ck_bug",           name: "不具合再現",       with_url: false, toast_p: false, with_talk: true,  },
      { key: "ck_silent",        name: "SFENと一緒に送る", with_url: false, toast_p: false, with_talk: true,  },
    ]
  }
}
