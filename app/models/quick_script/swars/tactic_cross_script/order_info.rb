class QuickScript::Swars::TacticCrossScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :popular,  name: "頻度", human_name: "人気", order_by: :"頻度", float_width: 4, el_message: "人気のある順", },
      { key: :win_rate, name: "勝率", human_name: "勝率", order_by: :"勝率", float_width: 3, el_message: "強い順",       },
    ]
  end
end
