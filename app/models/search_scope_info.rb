class SearchScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :ss_public,     name: "みんなの",     icon_key: "account-multiple", },
    { key: :ss_my_public,  name: "公開",         icon_key: "account",          },
    { key: :ss_my_private, name: "非公開",       icon_key: "lock",             },
    { key: :ss_my_all,     name: "自分のすべて", icon_key: nil,                },
  ]
end
