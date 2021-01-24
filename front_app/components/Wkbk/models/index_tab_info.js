import MemoryRecord from 'js-memory-record'

// 「全体」があったりして構造が異なるのでサーバー側で定義したものを利用していない
export class IndexTabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "everyone",     name: "全体",   },
      { key: "public",  name: "公開",   },
      { key: "private", name: "非公開", },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}
