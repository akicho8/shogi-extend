import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class CcBehaviorInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "cc_behavior_on",            receive_message: "時計を設置しました", label: "時計 ON",          label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: true,  with_talk: true,  history: true,  },
      { key: "cc_behavior_off",           receive_message: "時計を捨てました",   label: "時計 OFF",         label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: true,  with_talk: true,  history: true,  },
      { key: "cc_behavior_input",         receive_message: "時計を調整しました", label: "時間調整",         label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: false, with_talk: false, history: false, },
      { key: "cc_behavior_start",         receive_message: "対局を開始しました", label: "対局開始",         label_type: "is-primary", with_url: false, with_member_data: true,  log_level: "info", toast_p: false, with_talk: false, history: true,  }, // 特別処理
      { key: "cc_behavior_pause",         receive_message: "一時停止しました",   label: "一時停止",         label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: true,  with_talk: true,  history: true,  },
      { key: "cc_behavior_silent_pause",  receive_message: null,                 label: "一時停止",         label_type: "is-primary", with_url: false, with_member_data: false, log_level: "info", toast_p: false, with_talk: false, history: true,  },
      { key: "cc_behavior_resume",        receive_message: "時計を再開しました", label: "時計再開",         label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: true,  with_talk: true,  history: true,  },
      { key: "cc_behavior_silent_resume", receive_message: null,                 label: "時計再開",         label_type: "is-primary", with_url: false, with_member_data: false, log_level: null,   toast_p: false, with_talk: false, history: true,  },
      { key: "cc_behavior_stop",          receive_message: "時計を停止しました", label: "時計停止",         label_type: "is-primary", with_url: true,  with_member_data: true,  log_level: "info", toast_p: true,  with_talk: true,  history: true,  },
      { key: "cc_behavior_silent_stop",   receive_message: null,                 label: "時計停止",         label_type: "is-primary", with_url: true,  with_member_data: true,  log_level: "info", toast_p: false, with_talk: false, history: true,  },
      { key: "cc_behavior_timeout",       receive_message: null,                 label: "時間切れ",         label_type: "is-danger",  with_url: true,  with_member_data: false, log_level: "info", toast_p: false, with_talk: false, history: true,  }, // 特別処理
      { key: "cc_behavior_manual_sync",   receive_message: "手動同期",           label: "手動同期",         label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: true,  with_talk: true,  history: true,  },
      { key: "cc_behavior_bug",           receive_message: "不具合再現",         label: "不具合再現",       label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: false, with_talk: true,  history: true,  },
      { key: "cc_behavior_silent",        receive_message: "SFENと一緒に送る",   label: "SFENと一緒に送る", label_type: null,         with_url: false, with_member_data: false, log_level: null,   toast_p: false, with_talk: false, history: false, },
    ]
  }

  get name() {
    return this.label
  }
}
