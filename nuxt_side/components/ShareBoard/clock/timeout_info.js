import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class TimeoutInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "self_notify", name: "自首", desc: "時間切れになったので自分で通知した場合",                             },
      { key: "audo_judge",  name: "判定", desc: "時間切れの間近で当事者が切断を行い他者による自動勝ち判定をした場合", },
    ]
  }
}
