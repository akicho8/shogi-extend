module Actf
  class FinalInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :give_up,    name: "ギブアップ", lose_side: true,  },
      { key: :disconnect, name: "接続切れ",   lose_side: true,  },
      { key: :all_clear,  name: "全クリ",     lose_side: false, },
    ]
  end
end
