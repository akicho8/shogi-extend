module Wkbk
  class SequenceInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "shuffle",         name: "シャッフル",       apply: -> v { v.shuffle                                              } },
      { key: "title_asc",       name: "タイトル昇順",     apply: -> v { v.reorder(title: :asc)                                 } },
      { key: "title_desc",      name: "タイトル降順",     apply: -> v { v.reorder(title: :desc)                                } },
      { key: "difficulty_asc",  name: "難易度昇順",       apply: -> v { v.reorder(difficulty: :asc).order(Arel.sql("RAND()"))  } },
      { key: "difficulty_desc", name: "難易度降順",       apply: -> v { v.reorder(difficulty: :desc).order(Arel.sql("RAND()")) } },
      { key: "created_at_asc",  name: "問題作成日時昇順", apply: -> v { v.reorder(created_at: :asc)                            } },
      { key: "created_at_desc", name: "問題作成日時降順", apply: -> v { v.reorder(created_at: :desc)                           } },
      { key: "updated_at_asc",  name: "問題更新日時昇順", apply: -> v { v.reorder(updated_at: :asc)                            } },
      { key: "updated_at_desc", name: "問題更新日時降順", apply: -> v { v.reorder(updated_at: :desc)                           } },
      { key: "customize",       name: "カスタマイズ",     apply: -> v { v.reorder(:position)                                   } },
    ]
  end
end
