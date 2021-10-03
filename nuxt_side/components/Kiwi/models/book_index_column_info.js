import MemoryRecord from 'js-memory-record'

export class BookIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "key",                 name: "KEY",      visible: false, togglable: true,  },
      { key: "title",               name: "動画",     visible: true,  togglable: false, },
      { key: "access_logs_count",   name: "視聴",     visible: true,  togglable: true,  },
      { key: "book_messages_count", name: "コメ",     visible: true,  togglable: true,  },
      { key: "folder_key",          name: "公開設定", visible: true,  togglable: true,  },
      { key: "created_at",          name: "作成日時", visible: false, togglable: true,  },
      { key: "updated_at",          name: "最終更新", visible: true,  togglable: true,  },
    ]
  }
}
