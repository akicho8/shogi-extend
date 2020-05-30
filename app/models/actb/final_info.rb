module Actb
  class FinalInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :f_give_up,    name: "ギブアップ", lose_side: true,  },
      { key: :f_disconnect, name: "接続切れ",   lose_side: true,  },
      { key: :f_success,    name: "全クリ",     lose_side: false, },
      { key: :f_pending,    name: "未決定",     lose_side: false, },
    ]
  end
end
