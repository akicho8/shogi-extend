import MemoryRecord from 'js-memory-record'

export class QuestionIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",                  name: "ID",       short_name: "ID",       visible: false, },
      { key: "user_id",             name: "投稿者",   short_name: "投稿者",   visible: false, },
      { key: "source_author",       name: "作者",     short_name: "作者",     visible: false, },

      { key: "title",               name: "タイトル", short_name: "タイトル", visible: true,  },
      { key: "histories_count",     name: "出題数",   short_name: "出題",     visible: false, },
      { key: "o_rate",              name: "正解率",   short_name: "正解率",   visible: true,  },
      { key: "o_count",             name: "正解数",   short_name: "正解",     visible: false, },
      { key: "x_count",             name: "誤答数",   short_name: "誤答",     visible: false, },
      { key: "messages_count",      name: "コメ数",   short_name: "コメ",     visible: true,  },

      { key: "good_rate",           name: "高評価率", short_name: "高率",     visible: true,  },
      { key: "good_marks_count",    name: "高評価",   short_name: "高評",     visible: false, },
      { key: "bad_marks_count",     name: "低評価",   short_name: "低評",     visible: false, },

      // { key: "clip_marks_count", name: "被保存",   short_name: "被保",     visible: false, },
      // { key: "difficulty_level", name: "難易度",   short_name: "難度",     visible: false, },
      // { key: "time_limit_sec",   name: "制限時間", short_name: "時間",     visible: false, },
      { key: "lineage_key",         name: "種類",     short_name: "種類",     visible: false, },
      { key: "turn_max",            name: "手数",     short_name: "手数",     visible: false, },
      { key: "moves_answers_count", name: "解何通",   short_name: "解通",     visible: false, },
      { key: "owner_tag_list",      name: "タグ",     short_name: "タグ",     visible: false, },

      { key: "created_at",          name: "作成日時", short_name: "作成",     visible: false, },
      { key: "updated_at",          name: "更新日時", short_name: "更新",     visible: false, },
    ]
  }
}
