module QuickScript
  class SgroupInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :dev,    name: "開発用",       admin_only: true,  },
      { key: :admin,  name: "管理者用",     admin_only: true,  },
      { key: :chore,  name: "雑用",         admin_only: false, },
      { key: :group1, name: "GROUP1",       admin_only: false, },
      { key: :swars,  name: "将棋ウォーズ", admin_only: false, },
    ]

    def link_path
      "/script/#{key}"
    end
  end
end
