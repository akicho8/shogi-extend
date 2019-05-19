class SaturnInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :public,  name: "公開",     icon: "" },
    { key: :private, name: "自分だけ", icon: "key" },
  ]
end
