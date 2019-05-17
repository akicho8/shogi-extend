class SearchScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :ss_public,     name: "全体",         },
    { key: :ss_my_public,  name: "自分の公開",   },
    { key: :ss_my_private, name: "自分の非公開", },
    { key: :ss_my_all,     name: "自分の全部",   },
  ]
end
