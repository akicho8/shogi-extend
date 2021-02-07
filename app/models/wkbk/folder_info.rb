module Wkbk
  class FolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :public,  name: "公開",     },
      { key: :limited, name: "限定公開", },
      { key: :private, name: "非公開",   },
    ]
  end
end
