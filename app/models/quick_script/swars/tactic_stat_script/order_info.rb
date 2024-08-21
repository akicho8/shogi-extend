class QuickScript::Swars::TacticStatScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win_rate, name: "勝率", order_by: :win_ratio,  el_message: "WIN ÷ (WIN + LOSE)",                  },
      { key: :popular,  name: "人気", order_by: :freq_count, el_message: "人気というより単に出現数の多いもの順", },
    ]
  end
end
