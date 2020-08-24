# -*- compile-command: "rails r 'Xclock::EmotionFolder.setup; tp Xclock::EmotionFolder'" -*-

module Xclock
  # rails r "tp Xclock::EmotionFolderInfo.as_json"
  # rails r "puts Xclock::EmotionFolderInfo.to_json"
  # rails r "tp Xclock::EmotionFolder.destroy_all"
  class EmotionFolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :question, name: "問題",     type: "is-primary", },
      { key: :versus,   name: "対局",     type: "is-primary", },
      { key: :trash,    name: "ゴミ箱",   type: "is-danger",  },
    ]
  end
end
# ~> -:8:in `<class:EmotionFolderInfo>': uninitialized constant Xclock::EmotionFolderInfo::ApplicationMemoryRecord (NameError)
# ~> 	from -:7:in `<module:Xclock>'
# ~> 	from -:3:in `<main>'
