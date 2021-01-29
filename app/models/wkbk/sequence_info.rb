module Wkbk
  class SequenceInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "shuffle",         name: "シャッフル",       apply: -> v { v.shuffle } },
      { key: "created_at_asc",  name: "問題作成日時昇順", apply: -> v { v.reorder(created_at: :asc)  } },
      { key: "created_at_desc", name: "問題作成日時降順", apply: -> v { v.reorder(created_at: :desc) } },
      { key: "updated_at_asc",  name: "問題更新日時昇順", apply: -> v { v.reorder(updated_at: :asc)  } },
      { key: "updated_at_desc", name: "問題更新日時降順", apply: -> v { v.reorder(updated_at: :desc) } },
    ]
  end
end
