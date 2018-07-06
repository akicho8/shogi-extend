module Fanta
  class TeamInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :team_p1vs1,  name: "シングルス", half_limit: 1, },
      { key: :team_p2vs2,  name: "ダブルス",   half_limit: 2, },
      { key: :team_p4vs4,  name: "チーム戦",   half_limit: 4, },
    ]

    def total_limit
      half_limit * 2
    end
  end
end
