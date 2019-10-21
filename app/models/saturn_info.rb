class SaturnInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :public,  name: "世界に公開", icon: "earth", char_key: "1", },
    { key: :private, name: "自分だけ",   icon: "lock",  char_key: "0", },
  ]
end
