class QuickScript::Swars::TacticHistogramScript
  class TacticInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :attack,
        name: "戦型",
      },
      {
        key: :defense,
        name: "囲い",
      },
      {
        key: :technique,
        name: "手筋",
      },
      {
        key: :note,
        name: "備考",
        el_message: "備考は異なるタイプの値が混在しているため全体での比較にはほとんど意味がない。「居飛車」と「振り飛車」などを部分的にペアにして見る。",
      },
    ]

    def ancestor_info
      Bioshogi::Explain::TacticInfo.fetch(key)
    end

    def tag_table
      "#{key}_tags"
    end
  end
end
