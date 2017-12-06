class WinLoseInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: :win,  name: "勝ち",     },
    {key: :lose, name: "負け",     },
    {key: :draw, name: "引き分け", },
  ]

  def battle_ships
    BattleShip.where(win_lose_key: key)
  end
end
