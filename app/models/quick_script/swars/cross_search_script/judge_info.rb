class QuickScript::Swars::CrossSearchScript
  class JudgeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win,  name: "勝ち",     },
      { key: :lose, name: "負け",     },
      { key: :draw, name: "引き分け", },
    ]
  end
end
