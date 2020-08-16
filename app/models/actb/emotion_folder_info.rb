# -*- compile-command: "rails r 'Actb::EmotionFolder.setup; tp Actb::EmotionFolder'" -*-

module Actb
  # rails r "tp Actb::EmotionFolderInfo.as_json"
  # rails r "puts Actb::EmotionFolderInfo.to_json"
  # rails r "tp Actb::EmotionFolder.destroy_all"
  class EmotionFolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :question, name: "問題",     type: "is-primary", },
      { key: :versus,   name: "対局",     type: "is-primary", },
      { key: :trash,    name: "ゴミ箱",   type: "is-danger",  },
    ]
  end
end
# ~> -:8:in `<class:EmotionFolderInfo>': uninitialized constant Actb::EmotionFolderInfo::ApplicationMemoryRecord (NameError)
# ~> 	from -:7:in `<module:Actb>'
# ~> 	from -:3:in `<main>'
