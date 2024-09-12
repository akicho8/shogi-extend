class QuickScript::Swars::CrossSearchScript
  class TagCondInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :and,  name: "すべて含む",     el_message: %(AND条件。例: "居飛車 急戦 穴熊の姿焼き"), tagged_with_options: {               }, }, # match_all ではない
      { key: :or,   name: "どれか含む",     el_message: %(OR条件。例: "嬉野流 新嬉野流"),           tagged_with_options: { any: true     }, },
      { key: :not,  name: "どれも含まない", el_message: %(NOT条件。例: "稲庭戦法 穴角戦法"),        tagged_with_options: { exclude: true }, },
    ]
  end
end
