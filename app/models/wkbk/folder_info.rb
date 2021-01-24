module Wkbk
  class FolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :private, name: "非公開", },
      { key: :public,  name: "公開",   },
    ]
  end
end
