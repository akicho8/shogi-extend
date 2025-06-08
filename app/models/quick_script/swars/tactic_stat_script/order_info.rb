class QuickScript::Swars::TacticStatScript
  class OrderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win_rate,   name: "勝率",   float_width: 3, attr_key: :"勝率",   el_message: "勝率で並べる", },
      { key: :popular,    name: "人気度", float_width: 4, attr_key: :"人気度", el_message: "人気度 (使用人数でも同じ) で並べる。みんなで使うと上がる。", },
      { key: :frequently, name: "出現率", float_width: 4, attr_key: :"出現率", el_message: "出現率 (出現回数でも同じ) で並べる。一人で使いまくっても上がる。", },
    ]
  end
end
