class QuickScript::Swars::TacticStatScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win_rate,   name: "勝率", order_by: :"勝率",   el_message: "「勝率」で並べる", },
      { key: :popular,    name: "人気", order_by: :"人気度", el_message: "「人気度」で並べる。「使用人数」でも同じ。たくさんの人が使うと上がる。", },
      { key: :frequently, name: "登場", order_by: :"登場率", el_message: "「登場率」で並べる。「登場回数」でも同じ。一人で使いまくっても上がる。", },
    ]
  end
end
