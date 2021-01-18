# -*- compile-command: "rails r 'Wbook::EmotionFolder.setup; tp Wbook::EmotionFolder'" -*-

module Wbook
  # rails r "tp Wbook::EmotionFolderInfo.as_json"
  # rails r "puts Wbook::EmotionFolderInfo.to_json"
  # rails r "tp Wbook::EmotionFolder.destroy_all"
  class EmotionFolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :question, name: "問題",     type: "is-primary", },
      { key: :versus,   name: "対局",     type: "is-primary", },
      { key: :trash,    name: "ゴミ箱",   type: "is-danger",  },
    ]
  end
end
# ~> -:8:in `<class:EmotionFolderInfo>': uninitialized constant Wbook::EmotionFolderInfo::ApplicationMemoryRecord (NameError)
# ~> 	from -:7:in `<module:Wbook>'
# ~> 	from -:3:in `<main>'
