class QuickScript::Swars::TacticStatScript
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
        el_message: "備考は異なるグループが混在しているため全体での比較には意味がない。たとえば「居飛車」と「入玉」を比べても意味がない。「居飛車」なら「振り飛車」と比べる。",
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
