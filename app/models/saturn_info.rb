class SaturnInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :public,  name: "公開",     },
    { key: :private, name: "自分だけ", },
  ]
end
