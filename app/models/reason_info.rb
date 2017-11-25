class ReasonInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "TORYO",      name: "投了",     label_key: nil,     csa_key: "TORYO",   },
    {key: "DISCONNECT", name: "切断",     label_key: :danger, csa_key: "CHUDAN",  },
    {key: "TIMEOUT",    name: "時間切れ", label_key: nil,     csa_key: "TIMEOUT", },
    {key: "CHECKMATE",  name: "詰み",     label_key: nil,     csa_key: "TSUMI",   },
  ]
end
