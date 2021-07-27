class ActionCableEventInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :initialized,  name: "初期", short_name: "初", },
    { key: :connected,    name: "接続", short_name: "接", },
    { key: :disconnected, name: "切断", short_name: "切", },
    { key: :rejected,     name: "拒否", short_name: "拒", },
    { key: :received,     name: "受信", short_name: "受", },
  ]
end
