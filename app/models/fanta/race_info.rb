module Fanta
  class RaceInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :robot, name: "ロボット", auto_kotaeru: true,  auto_kangaeru: true,  auto_iku: true,  auto_hand: true,  },
      { key: :human, name: "人間",     auto_kotaeru: false, auto_kangaeru: false, auto_iku: false, auto_hand: false, },
    ]
  end
end
