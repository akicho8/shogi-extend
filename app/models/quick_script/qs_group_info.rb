module QuickScript
  class QsGroupInfo
    include ApplicationMemoryRecord
    memory_record [
      # ここの情報が先。
      # グループはディレクトリを作るだけでなく先にここに登録する。
      { key: :"swars",   name: "将棋ウォーズ", admin_only: false, sitemap: true,  },
      { key: :"general", name: "一般",         admin_only: false, sitemap: true,  },
      { key: :"tool",    name: "ツール",       admin_only: false, sitemap: true,  },
      { key: :"chore",   name: "雑用",         admin_only: false, sitemap: true,  },
      { key: :"account", name: "アカウント",   admin_only: false, sitemap: true,  },
      { key: :"about",   name: "About",        admin_only: false, sitemap: true,  },
      { key: :"dev",     name: "開発用",       admin_only: true,  sitemap: false, }, # [REFS] BASIC_AUTH_MATCH
      { key: :"admin",   name: "管理者用",     admin_only: true,  sitemap: false, }, # [REFS] BASIC_AUTH_MATCH
      { key: :"group1",  name: "GROUP1",       admin_only: true,  sitemap: false, }, # [REFS] BASIC_AUTH_MATCH
    ]

    def qs_path
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
