import MemoryRecord from 'js-memory-record'

export class QuestionColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",               name: "ID",         short_name: "ID",       visible: true,  },
      { key: "title",            name: "タイトル",   short_name: "タイトル", visible: true,  },
      { key: "difficulty_level", name: "難易度",     short_name: "難度",     visible: false, },
      { key: "o_count",          name: "正解数",     short_name: "正解",     visible: false, },
      { key: "x_count",          name: "誤答数",     short_name: "誤答",     visible: false, },
      { key: "histories_count",  name: "履歴",       short_name: "履歴",     visible: false, },
      { key: "good_marks_count", name: "高評価",     short_name: "高評",     visible: true,  },
      { key: "bad_marks_count",  name: "低評価",     short_name: "低評",     visible: true,  },
      { key: "clip_marks_count", name: "被保存",     short_name: "被保",     visible: false, },
      { key: "updated_at",       name: "更新日時",   short_name: "更新",     visible: true,  },
    ]
  }
}
