module Wkbk
  # front_app/components/Wkbk/models/sequence_info.js
  class SequenceInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "bookship_shuffle",         name: "シャッフル",        apply: -> v { v.reorder(Arel.sql("RAND()"))                                             } },
      { key: "article_difficulty_asc",   name: "難易度 (易しい順)", apply: -> v { v.reorder(Article.arel_table[:difficulty].asc).order(Arel.sql("RAND()"))  } },
      { key: "article_difficulty_desc",  name: "難易度 (難しい順)", apply: -> v { v.reorder(Article.arel_table[:difficulty].desc).order(Arel.sql("RAND()")) } },
      { key: "article_turn_max_asc",     name: "手数 (少ない順)",   apply: -> v { v.reorder(Article.arel_table[:turn_max].asc)                              } },
      { key: "article_turn_max_desc",    name: "手数 (多い順)",     apply: -> v { v.reorder(Article.arel_table[:turn_max].desc)                             } },
      { key: "bookship_created_at_asc",  name: "追加日 (古い順)",   apply: -> v { v.reorder(Bookship.arel_table[:created_at].asc)                           } },
      { key: "bookship_created_at_desc", name: "追加日 (新しい順)", apply: -> v { v.reorder(Bookship.arel_table[:created_at].desc)                          } },
      { key: "article_created_at_asc",   name: "作成日 (古い順)",   apply: -> v { v.reorder(Article.arel_table[:created_at].asc)                            } },
      { key: "article_created_at_desc",  name: "作成日 (新しい順)", apply: -> v { v.reorder(Article.arel_table[:created_at].desc)                           } },
      { key: "article_title_asc",        name: "タイトル (正順)",   apply: -> v { v.reorder(Article.arel_table[:title].asc)                                 } },
      { key: "article_title_desc",       name: "タイトル (逆順)",   apply: -> v { v.reorder(Article.arel_table[:title].desc)                                } },
      { key: "bookship_position_asc",    name: "カスタマイズ",      apply: -> v { v.reorder(Bookship.arel_table[:position].asc)                             } },
    ]
  end
end
