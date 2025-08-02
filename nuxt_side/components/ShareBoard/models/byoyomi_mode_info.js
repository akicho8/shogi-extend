import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ByoyomiModeInfo extends ApplicationMemoryRecord {
  static field_label = "秒読み"
  static field_message = ""

  static get define() {
    return [
      { key: "byoyomi_mode_9s",  name: "9",    type: "is-primary", interval_yomi: true,  byoyomi: 9, message: "9秒から読む", },
      { key: "byoyomi_mode_5s",  name: "5",    type: "is-primary", interval_yomi: true,  byoyomi: 5, message: "5秒から読む", },
      { key: "byoyomi_mode_4s",  name: "4",    type: "is-warning", interval_yomi: true,  byoyomi: 4, message: "4秒から読む", },
      { key: "byoyomi_mode_3s",  name: "3",    type: "is-warning", interval_yomi: true,  byoyomi: 3, message: "3秒から読む", },
      { key: "byoyomi_mode_2s",  name: "2",    type: "is-warning", interval_yomi: true,  byoyomi: 2, message: "2秒から読む", },
      { key: "byoyomi_mode_1s",  name: "1",    type: "is-warning", interval_yomi: true,  byoyomi: 1, message: "1秒から読む", },
      { key: "byoyomi_mode_off", name: "なし", type: "is-danger",  interval_yomi: false, byoyomi: 0, message: "読まない",    },
    ]
  }
}
