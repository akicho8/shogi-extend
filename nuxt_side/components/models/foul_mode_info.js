import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class FoulModeInfo extends ApplicationMemoryRecord {
  static field_label = "反則"
  static message = null
  static hint_messages = ["二歩・王手放置・駒ワープを警告します(初心者向け)"]

  static get define() {
    return [
      { key: "is_foul_mode_on",  name: "自由", message: "二歩・王手放置可", },
      { key: "is_foul_mode_off", name: "制限", message: "反則手は指せない", },
    ]
  }
}
