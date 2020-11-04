module Emox
  class FolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :active, name: "公開",   icon: "check",             type: "is-primary", },
      { key: :draft,  name: "下書き", icon: "lock-outline",      type: "is-warning", },
      { key: :trash,  name: "ゴミ箱", icon: "trash-can-outline", type: "is-danger",  },
    ]
  end
end
