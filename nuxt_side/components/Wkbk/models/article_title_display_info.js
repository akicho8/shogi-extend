import { ApplicationMemoryRecord } from "@/components/models/application_memory_record.js"

export class ArticleTitleDisplayInfo extends ApplicationMemoryRecord {
  static field_label = "問題タイトルを表示"

  static get define() {
    return [
      { key: "display", name: "する",   },
      { key: "hidden",  name: "しない", },
    ]
  }
}
