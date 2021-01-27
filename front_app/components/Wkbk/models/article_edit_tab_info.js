import MemoryRecord from 'js-memory-record'

export class ArticleEditTabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "placement",  name: "配置", },
      { key: "answer",     name: "正解", },
      { key: "form",       name: "情報", },
      { key: "validation", name: "検証", },
    ]
  }
}
