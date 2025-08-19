module Ppl
  class RankInfo
    include ApplicationMemoryRecord
    memory_record [
      # { key: "昇段",         name: "昇段", official_mark: "昇", },
      # { key: "フリークラス", name: "降段", official_mark: "降", },
      # { key: "退会",         name: "次点", official_mark: "次", },
      # { key: :retain,        name: "維持", official_mark: "維", },
    ]

    # prepend AliasMod
    # 
    # def secondary_key
    #   [name, official_mark]
    # end
  end
end
