module QuickScript
  class QsGroupInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :"swars",  name: "将棋ウォーズ", admin_only: false, },
      { key: :"chore",  name: "雑用",         admin_only: false, },
      { key: :"dev",    name: "開発用",       admin_only: true,  }, # [REFS] BASIC_AUTH_MATCH
      { key: :"admin",  name: "管理者用",     admin_only: true,  },
      { key: :"group1", name: "GROUP1",       admin_only: true,  },
    ]

    def qs_link_path
      "/lab/#{key}".dasherize
    end

    def name
      if admin_only
        return "*#{super}*"
      end
      super
    end
  end
end
