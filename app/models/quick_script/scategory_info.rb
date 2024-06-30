module QuickScript
  class ScategoryInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :admin,  name: "管理",   admin_required: true,  },
      { key: :chore,  name: "雑用",   admin_required: false, },
      { key: :group1, name: "GROUP1", admin_required: false, },
    ]

    def link_path
      "/script/#{key}"
    end
  end
end
