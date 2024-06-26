import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class FolderInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "public",   name: "公開",     icon: "eye-outline",  type: null, message: "誰でも見れる", },
      { key: "limited",  name: "限定公開", icon: "link",         type: null, message: "リンクを伝えた人だけ見れる", },
      { key: "private",  name: "非公開",   icon: "lock",         type: null, message: "本人だけ見れる", },
    ]
  }
}
