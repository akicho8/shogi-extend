class ReasonInfo
  include ApplicationMemoryRecord
  memory_record [
    {key: "TORYO",         name: "投了",                           },
    {key: "DISCONNECT",    name: "接続切れ",                       },
    {key: "TIMEOUT",       name: "時間切れ",                       },
    {key: "CHECKMATE",     name: "時間切れ",                       },
    # {key: "ENTERINGKING",  name: "先手が入玉宣言して勝ち?",                      },
    # {key: "OUTE_SENNICHI", name: "後手連続王手の千日手による反則負け", },
  ]

  # class << self
  #   def kekka_key_to_record(str)
  #     str.match?(/^SENTE_WIN_/)
  #   end
  # end
end
