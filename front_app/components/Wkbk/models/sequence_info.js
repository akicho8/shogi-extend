import MemoryRecord from 'js-memory-record'

export class SequenceInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "shuffle",         name: "シャッフル",       },
      { key: "created_at_asc",  name: "問題作成日時昇順", },
      { key: "created_at_desc", name: "問題作成日時降順", },
      { key: "updated_at_asc",  name: "問題更新日時昇順", },
      { key: "updated_at_desc", name: "問題更新日時降順", },
    ]
  }
}
