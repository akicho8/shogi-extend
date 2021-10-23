import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class ShoutModeInfo extends ApplicationMemoryRecord {
  static get message() { return null }

  static get define() {
    return [
      { key: "is_shout_mode_off", name: "なし", message: "叫ばない",         },
      { key: "is_shout_mode_on",  name: "あり", message: "いちいち駒が叫ぶ", },
    ]
  }
}
