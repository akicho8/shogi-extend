class GeneralWstateInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "ILLEGAL_MOVE",  name: "反則",   label_key: :danger,   draw: false, },
    {key: "SENNICHITE",    name: "千日手", label_key: :warning,  draw: true,  },
    {key: "TORYO",         name: "投了",   label_key: nil,       draw: false, },
  ]
end
