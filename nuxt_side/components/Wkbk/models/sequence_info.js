import ApplicationMemoryRecord from "@/components/models/application_memory_record.js"

// app/models/wkbk/sequence_info.rb
export class SequenceInfo extends ApplicationMemoryRecord {
  static get define() {
    return [
      { key: "bookship_shuffle",         name: "シャッフル",        },
      { key: "article_difficulty_asc",   name: "難易度 (易しい順)", },
      { key: "article_difficulty_desc",  name: "難易度 (難しい順)", },
      { key: "article_turn_max_asc",     name: "手数 (少ない順)",   },
      { key: "article_turn_max_desc",    name: "手数 (多い順)",     },
      { key: "bookship_created_at_asc",  name: "追加日 (古い順)",   },
      { key: "bookship_created_at_desc", name: "追加日 (新しい順)", },
      { key: "article_created_at_asc",   name: "作成日 (古い順)",   },
      { key: "article_created_at_desc",  name: "作成日 (新しい順)", },
      { key: "article_title_asc",        name: "タイトル (正順)",   },
      { key: "article_title_desc",       name: "タイトル (逆順)",   },
      { key: "bookship_position_asc",    name: "カスタマイズ",      },
    ]
  }
}
