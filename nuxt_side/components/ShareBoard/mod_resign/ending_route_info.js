import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class EndingRouteInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "er_manual_normal",  name: "投了",           notify_method_key: "toast",  },
      { key: "er_manual_illegal", name: "反則からの投了", notify_method_key: "toast",  },
      { key: "er_auto_checkmate", name: "詰み",           notify_method_key: "toast",  },
      { key: "er_auto_timeout",   name: "時間切れ",       notify_method_key: "silent", },
      { key: "er_auto_illegal",   name: "反則",           notify_method_key: "silent", },
      { key: "er_auto_draw",      name: "引き分け",       notify_method_key: "toast",  }, // 呼ばれることはない
    ]
  }

  // 簡易的な方法でユーザーに知らせるか？
  get toast_notify_p() {
    return this.notify_method_key === "toast"
  }

  // モーダルでユーザーに知らせるか？
  get modal_notify_p() {
    return this.notify_method_key === "modal"
  }
}
