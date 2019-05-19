class SaturnInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :public,  name: "公開",     icon: nil,   char_key: "1", },
    { key: :private, name: "自分だけ", icon: "key", char_key: "0", },
  ]
end
