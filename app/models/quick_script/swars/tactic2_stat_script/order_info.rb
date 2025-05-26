class QuickScript::Swars::Tactic2StatScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win_rate, name: "勝率", order_by: :"勝率", },
      { key: :popular,  name: "人気", order_by: :"頻度", },

      # el_message: "WIN / (WIN + LOSE)",
      # el_message: "人気というより単に出現率順 (出現数 / 対局数)",
    ]
  end
end
