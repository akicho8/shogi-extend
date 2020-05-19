module Actb
  class KindInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "詰将棋", },
      { key: "手筋",   },
    ]
  end
end
