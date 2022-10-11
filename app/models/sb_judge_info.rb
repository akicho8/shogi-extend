class SbJudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :win,  name: "勝ち", icon: ":勝ち:", },
    { key: :lose, name: "負け", icon: ":負け:", },
    { key: :none, name: "不明", icon: ":棋譜:", },
  ]
end
