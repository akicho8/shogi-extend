class QuickScript::Swars::Tactic2StatScript
  class DetailInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :simple, name: "通常", el_message: "a", },
      { key: :detail, name: "詳細", el_message: "b", },
    ]
  end
end
