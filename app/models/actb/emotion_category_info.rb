# -*- compile-command: "rails r 'Actb::EmotionCategory.setup; tp Actb::EmotionCategory'" -*-

module Actb
  # rails r "tp Actb::EmotionCategoryInfo.as_json"
  # rails r "puts Actb::EmotionCategoryInfo.to_json"
  # rails r "tp Actb::EmotionCategory.destroy_all"
  class EmotionCategoryInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :question, name: "問題", },
      { key: :versus,   name: "対局", },
    ]
  end
end
