# -*- compile-command: "rails r 'Emox::EmotionFolder.setup; tp Emox::EmotionFolder'" -*-

module Emox
  # rails r "tp Emox::EmotionFolderInfo.as_json"
  # rails r "puts Emox::EmotionFolderInfo.to_json"
  # rails r "tp Emox::EmotionFolder.destroy_all"
  class EmotionFolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :question, name: "問題",     type: "is-primary", },
      { key: :versus,   name: "対局",     type: "is-primary", },
      { key: :trash,    name: "ゴミ箱",   type: "is-danger",  },
    ]
  end
end
# ~> -:8:in `<class:EmotionFolderInfo>': uninitialized constant Emox::EmotionFolderInfo::ApplicationMemoryRecord (NameError)
# ~> 	from -:7:in `<module:Emox>'
# ~> 	from -:3:in `<main>'
