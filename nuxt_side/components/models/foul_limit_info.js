import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class FoulLimitInfo extends ApplicationMemoryRecord {
  static field_label = "反則制限"
  static message = null
  static hint_messages = ["制限すると二歩・王手放置・駒ワープを指せなくします"]

  static get define() {
    return [
      { key: "is_foul_limit_off", name: "なし", message: "一般向け",   },
      { key: "is_foul_limit_on",  name: "あり", message: "初心者向け", },
    ]
  }
}
