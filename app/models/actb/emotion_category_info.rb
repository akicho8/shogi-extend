# -*- compile-command: "rails r 'Actb::EmotionCategory.setup; tp Actb::EmotionCategory'" -*-

module Actb
  # rails r "tp Actb::EmotionCategoryInfo.as_json"
  # rails r "puts Actb::EmotionCategoryInfo.to_json"
  # rails r "tp Actb::EmotionCategory.destroy_all"
  class EmotionCategoryInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :question, name: "問題",   type: "is-primary", },
      { key: :versus,   name: "対局",   type: "is-primary", },
      { key: :trash,    name: "ゴミ箱", type: "is-danger",  },
    ]
  end
end
# ~> -:8:in `<class:EmotionCategoryInfo>': uninitialized constant Actb::EmotionCategoryInfo::ApplicationMemoryRecord (NameError)
# ~> 	from -:7:in `<module:Actb>'
# ~> 	from -:3:in `<main>'
