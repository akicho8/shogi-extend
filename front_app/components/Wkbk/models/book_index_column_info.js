import MemoryRecord from 'js-memory-record'

export class BookIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",             name: "ID",       visible: false, togglable: true,  },
      { key: "title",          name: "タイトル", visible: null,  togglable: false, },
      { key: "user_id",        name: "投稿",   visible: null,  togglable: false, },
      { key: "articles_count", name: "問題数",   visible: false, togglable: true,  },
      { key: "created_at",     name: "作成日時", visible: false, togglable: true,  },
      { key: "updated_at",     name: "更新日時", visible: true,  togglable: true,  },
    ]
  }
}
