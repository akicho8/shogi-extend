import MemoryRecord from 'js-memory-record'

export class QuestionIndexColumnInfo extends MemoryRecord {
  static get define() {
    return [
      { key: "id",               name: "ID",         short_name: "ID",       visible: false, scope: ["admin", "general"],          },
      { key: "user_id",          name: "作成者",     short_name: "作成者",   visible: false, scope: ["admin", "general"],          },

      { key: "title",            name: "タイトル",   short_name: "タイトル", visible: true,  scope: ["admin", "general"],          },
      { key: "histories_count",  name: "出題数",     short_name: "出題",     visible: false, scope: ["admin", "general"],          },
      { key: "o_rate",           name: "正解率",     short_name: "正解率",   visible: true,  scope: ["admin", "general"],          },
      { key: "o_count",          name: "正解数",     short_name: "正解",     visible: false, scope: ["admin", "general"],          },
      { key: "x_count",          name: "誤答数",     short_name: "誤答",     visible: false, scope: ["admin", "general"],          },
      { key: "messages_count",   name: "コメ数",     short_name: "コメ",     visible: true,  scope: ["admin", "general"],          },

      { key: "good_rate",        name: "高評価率",   short_name: "高率",     visible: true,  scope: ["admin", "general"],          },
      { key: "good_marks_count", name: "高評価",     short_name: "高評",     visible: false, scope: ["admin", "general"],          },
      { key: "bad_marks_count",  name: "低評価",     short_name: "低評",     visible: false, scope: ["admin", "general"],          },

      { key: "clip_marks_count", name: "被保存",     short_name: "被保",     visible: false, scope: ["admin", "general"],          },
      { key: "difficulty_level", name: "難易度",     short_name: "難度",     visible: false, scope: ["admin", "general"],          },
      { key: "time_limit_sec",   name: "制限時間",   short_name: "時間",     visible: false, scope: ["admin", "general"],          },
      { key: "lineage_key",      name: "種類",       short_name: "種類",     visible: false, scope: ["admin", "general"],          },

      { key: "created_at",       name: "作成日時",   short_name: "作成",     visible: false, scope: ["admin", "general"],          },
      { key: "updated_at",       name: "更新日時",   short_name: "更新",     visible: false, scope: ["admin", "general"],          },
    ]
  }
}
