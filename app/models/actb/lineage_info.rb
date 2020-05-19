module Actb
  class LineageInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "詰将棋" },
      { key: "手筋"   },
      { key: "必死"   },
      { key: "定跡"   },
      { key: "秘密"   },
    ]
  end
end
