class SearchScopeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :ss_public,     name: "一般",   },
    { key: :ss_my_public,  name: "公開",   },
    { key: :ss_my_private, name: "非公開", },
    # (!Rails.env.production? ? { key: :ss_my_all, name: "すべて", } : nil),
  ].compact
end
