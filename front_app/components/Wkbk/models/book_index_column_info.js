import MemoryRecord from 'js-memory-record'

export class BookIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",             name: "ID",       short_name: "ID",       visible: false, togglable: true,  },
      { key: "title",          name: "タイトル", short_name: "タイトル", visible: true,  togglable: false, },
      { key: "user_id",        name: "投稿者",   short_name: "投稿者",   visible: false, togglable: false, },
      { key: "articles_count", name: "問題数",   short_name: "解通",     visible: false, togglable: true,  },
      { key: "owner_tag_list", name: "タグ",     short_name: "タグ",     visible: false, togglable: true,  },
      { key: "created_at",     name: "作成日時", short_name: "作成",     visible: false, togglable: true,  },
      { key: "updated_at",     name: "更新日時", short_name: "更新",     visible: false, togglable: true,  },
    ]
  }
}
