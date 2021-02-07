# |----------+------+--------+-------------+-----------------------------|
# | 種類     | 一覧 | 直リン | 一覧条件    | 直リン表示条件              |
# |----------+------+--------+-------------+-----------------------------|
# | 公開     | ○   | ○     | public_only | true                        |
# | 限定公開 | ×   | ○     | public_only | true                        |
# | 非公開   | ×   | ×     | public_only | current_user == record.user |
# |----------+------+--------+-------------+-----------------------------|

module Wkbk
  class FolderInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :public,  name: "公開",     show_can: -> current_user, record { true                        } },
      { key: :limited, name: "限定公開", show_can: -> current_user, record { true                        } },
      { key: :private, name: "非公開",   show_can: -> current_user, record { current_user == record.user } },
    ]
  end
end
