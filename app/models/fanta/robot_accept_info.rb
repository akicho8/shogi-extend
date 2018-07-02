module Fanta
  class RobotAcceptInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "accept",     name: "する",   },
      { key: "not_accept", name: "しない", },
    ]
  end
end
