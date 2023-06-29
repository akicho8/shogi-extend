import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ByoyomiModeInfo extends ApplicationMemoryRecord {
  static field_label = "秒読み"
  static field_message = ""

  static get define() {
    return [
      { key: "byoyomi_mode_9s",  name: "9秒",   type: "is-primary",  minute_yomi: true,  byoyomi: 9, message: "分と30秒から10秒刻みと9秒から読む", },
      { key: "byoyomi_mode_5s",  name: "5秒",   type: "is-primary",  minute_yomi: true,  byoyomi: 5, message: "分と30秒から10秒刻みと5秒から読む", },
      { key: "byoyomi_mode_3s",  name: "3秒",   type: "is-warning",  minute_yomi: true,  byoyomi: 3, message: "分と30秒から10秒刻みと3秒から読む", },
      { key: "byoyomi_mode_0s",  name: "0秒",   type: "is-warning",  minute_yomi: true,  byoyomi: 0, message: "分と30秒から10秒刻みだけ読む",      },
      { key: "byoyomi_mode_off", name: "なし",  type: "is-danger",   minute_yomi: false, byoyomi: 0, message: "一切読まない",                      },
    ]
  }
}
