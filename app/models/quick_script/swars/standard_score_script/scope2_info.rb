class QuickScript::Swars::StandardScoreScript
  class Scope2Info
    include ApplicationMemoryRecord
    memory_record [
      { key: :sd,   name: "偏差値",   },
      { key: :dist, name: "全体分布", },
    ]
  end
end
