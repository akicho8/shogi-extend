import MemoryRecord from 'js-memory-record'

export class IndexScopeInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "everyone", name: "全体",   },
      { key: "public",   name: "公開",   },
      { key: "private",  name: "非公開", },
    ]
  }
}
