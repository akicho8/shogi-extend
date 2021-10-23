import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

export class ArticleEditTabInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "placement",  name: "配置", },
      { key: "answer",     name: "正解", },
      { key: "form",       name: "情報", },
      { key: "validation", name: "検証", },
    ]
  }
}
