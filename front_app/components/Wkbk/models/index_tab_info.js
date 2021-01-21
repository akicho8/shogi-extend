import MemoryRecord from 'js-memory-record'

// 「全体」があったりして構造が異なるのでサーバー側で定義したものを利用していない
export class IndexTabInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "all",    name: "全体",   hidden_if_empty: false, },
      { key: "active", name: "公開",   hidden_if_empty: false, },
      { key: "draft",  name: "下書き", hidden_if_empty: true,  },
      { key: "trash",  name: "ゴミ箱", hidden_if_empty: true,  },
    ]
  }

  get handle_method_name() {
    return `${this.key}_handle`
  }
}
