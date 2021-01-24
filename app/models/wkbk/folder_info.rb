module Wkbk
  class FolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :private, name: "非公開", icon: "lock-outline", type: "",           },
      { key: :public,  name: "公開",   icon: "check",        type: "is-primary", },
    ]
  end
end
