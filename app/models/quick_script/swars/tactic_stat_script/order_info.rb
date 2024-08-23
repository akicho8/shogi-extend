class QuickScript::Swars::TacticStatScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win_rate, name: "勝率", order_by: :win_ratio,  },
      { key: :popular,  name: "人気", order_by: :freq_count, },

      # el_message: "WIN / (WIN + LOSE)",
      # el_message: "人気というより単に出現率順 (出現数 / 対局数)",
    ]
  end
end
