class QuickScript::Swars::CrossSearchScript
  class TagCondInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :and,  name: "すべて含む",     el_message: %(AND条件 - タグ欄入力例「居飛車 持久戦 穴熊の姿焼き」), tagged_with_options: {}, },
      { key: :or,   name: "どれか含む",     el_message: %(OR条件 - タグ欄入力例「棒銀 棒金 棒玉」),              tagged_with_options: { any: true     }, },
      { key: :not,  name: "どれも含まない", el_message: %(NOT条件 - タグ欄入力例「稲庭戦法 穴角戦法 筋違い角」), tagged_with_options: { exclude: true }, },
    ]
  end
end
