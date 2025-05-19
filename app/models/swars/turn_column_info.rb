# frozen-string-literal: true

module Swars
  class TurnColumnInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :critical_turn, name: "衝突", },
      { key: :outbreak_turn, name: "開戦", },
      { key: :turn_max,      name: "手数", },
    ]
  end
end
