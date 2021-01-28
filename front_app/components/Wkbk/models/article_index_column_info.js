import MemoryRecord from 'js-memory-record'

export class ArticleIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",                  name: "ID",       short_name: "ID",       visible: false, togglable: true, },
      { key: "title",               name: "タイトル", short_name: "タイトル", visible: true,  togglable: false, },
      { key: "user_id",             name: "投稿者",   short_name: "投稿者",   visible: true,  togglable: false, },
      { key: "book_title",          name: "問題集",   short_name: "問題集",   visible: true,  togglable: true, },
      { key: "lineage_key",         name: "種類",     short_name: "種類",     visible: false, togglable: true, },
      { key: "turn_max",            name: "手数",     short_name: "手数",     visible: false, togglable: true, },
      { key: "owner_tag_list",      name: "タグ",     short_name: "タグ",     visible: false, togglable: true, },
      { key: "created_at",          name: "作成日時", short_name: "作成",     visible: false, togglable: true, },
      { key: "updated_at",          name: "更新日時", short_name: "更新",     visible: false, togglable: true, },
    ]
  }
}
