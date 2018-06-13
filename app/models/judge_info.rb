class JudgeInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :win,  name: "勝ち",     },
    {key: :lose, name: "負け",     },
    {key: :draw, name: "引き分け", },
  ]

  def battle_ships
    Swars::BattleShip.where(judge_key: key)
  end

  def general_battle_ships
    GeneralBattleShip.where(judge_key: key)
  end
end
