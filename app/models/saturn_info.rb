class SaturnInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :public,  name: "みんな見れる",   icon: nil,    char_key: "1", },
    { key: :private, name: "自分だけ見れる", icon: "lock", char_key: "0", },
  ]
end
