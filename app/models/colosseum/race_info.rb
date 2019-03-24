module Colosseum
  class RaceInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :robot, name: "ロボット", auto_request_ok: true,  auto_think: true,  auto_jump: true,  auto_hand: true,  auto_message_response: true,  },
      { key: :human, name: "人間",     auto_request_ok: false, auto_think: false, auto_jump: false, auto_hand: false, auto_message_response: false, },
    ]
  end
end
