# - 将棋ウォーズで使われているものに絞るため
# - SwarsCustomSearchApp.vue 用

module Swars
  class SwPresetInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "平手",     },
      { key: "角落ち",   },
      { key: "飛車落ち", },
      { key: "二枚落ち", },
      { key: "四枚落ち", },
      { key: "六枚落ち", },
      { key: "八枚落ち", },
      { key: "十枚落ち", },
    ]
  end
end
