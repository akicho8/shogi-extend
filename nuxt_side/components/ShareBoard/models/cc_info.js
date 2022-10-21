import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CcInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "ck_on",            receive_message: "時計を設置しました", label: "時計 ON",          label_type: null,         with_url: false, toast_p: true,  with_talk: true,  history: true,  },
      { key: "ck_off",           receive_message: "時計を捨てました",   label: "時計 OFF",         label_type: null,         with_url: false, toast_p: true,  with_talk: true,  history: true,  },
      { key: "ck_start",         receive_message: "開始しました",       label: "対局開始",         label_type: "is-primary", with_url: false, toast_p: false, with_talk: false, history: true,  }, // 特別処理
      { key: "ck_pause",         receive_message: "一時停止しました",   label: "一時停止",         label_type: null,         with_url: false, toast_p: true,  with_talk: true,  history: true,  },
      { key: "ck_resume",        receive_message: "時計を再開しました", label: "時計再開",         label_type: null,         with_url: false, toast_p: true,  with_talk: true,  history: true,  },
      { key: "ck_stop",          receive_message: "時計を停止しました", label: "時計停止",         label_type: "is-primary", with_url: true,  toast_p: true,  with_talk: true,  history: true,  },
      { key: "ck_silent_stop",   receive_message: "時計を停止しました", label: "時計停止",         label_type: "is-primary", with_url: true,  toast_p: true,  with_talk: false, history: true,  },
      { key: "ck_timeout",       receive_message: "時間切れ",           label: "時間切れ",         label_type: "is-danger",  with_url: true,  toast_p: false, with_talk: false, history: true,  }, // 特別処理
      { key: "ck_manual_sync",   receive_message: "手動同期",           label: "手動同期",         label_type: null,         with_url: false, toast_p: true,  with_talk: true,  history: true,  },
      { key: "ck_bug",           receive_message: "不具合再現",         label: "不具合再現",       label_type: null,         with_url: false, toast_p: false, with_talk: true,  history: true,  },
      { key: "ck_silent",        receive_message: "SFENと一緒に送る",   label: "SFENと一緒に送る", label_type: null,         with_url: false, toast_p: false, with_talk: false, history: false, },
    ]
  }
}
