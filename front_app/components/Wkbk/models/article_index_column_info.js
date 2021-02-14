import MemoryRecord from 'js-memory-record'

export class ArticleIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "key",            name: "KEY",      visible: false, togglable: true,  },
      { key: "title",          name: "問題",     visible: null,  togglable: false, },
      // { key: "user_id",        name: "投稿",     visible: true,  togglable: false, },
      { key: "book_title",     name: "問題集",   visible: true,  togglable: true,  },
      { key: "lineage_key",    name: "種類",     visible: true,  togglable: true,  },
      { key: "turn_max",       name: "手数",     visible: true,  togglable: true,  },
      { key: "difficulty",     name: "難易度",   visible: true,  togglable: true,  },
      { key: "tag_list", name: "タグ",     visible: true,  togglable: true,  },
      { key: "folder_key",     name: "公開設定", visible: true,  togglable: true,  },
      { key: "created_at",     name: "作成日時", visible: false, togglable: true,  },
      { key: "updated_at",     name: "最終更新", visible: true,  togglable: true,  },
    ]
  }
}
