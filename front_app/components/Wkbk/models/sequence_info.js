import MemoryRecord from 'js-memory-record'

// app/models/wkbk/sequence_info.rb
export class SequenceInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "shuffle",         name: "シャッフル",       },
      { key: "title_asc",       name: "タイトル昇順",     },
      { key: "title_desc",      name: "タイトル降順",     },
      { key: "difficulty_asc",  name: "難易度昇順",       },
      { key: "difficulty_desc", name: "難易度降順",       },
      { key: "created_at_asc",  name: "問題作成日時昇順", },
      { key: "created_at_desc", name: "問題作成日時降順", },
      { key: "updated_at_asc",  name: "問題最終更新昇順", },
      { key: "updated_at_desc", name: "問題最終更新降順", },
      { key: "position_asc",    name: "カスタマイズ",     },
    ]
  }
}
