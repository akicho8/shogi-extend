class QuickScript::Swars::TacticStatScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win_rate,   name: "勝率",   order_by: :"勝率",   el_message: "勝率で並べる", },
      { key: :frequently, name: "登場率", order_by: :"登場率", el_message: "登場率 (登場回数でも同じ) で並べる。一人で使いまくっても上がる。", },
      { key: :popular,    name: "人気度", order_by: :"人気度", el_message: "人気度 (使用人数でも同じ) で並べる。一人で使いまくっても上がらない。たくさんの人が使うと上がる。", },
    ]
  end
end
