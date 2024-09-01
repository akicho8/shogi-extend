class QuickScript::Swars::TacticStatScript
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :attack,
        name: "戦型",
        scope_block: -> av { av.find_all { |e| Bioshogi::Explain::AttackInfo[e[:tag_name]] } },
      },
      {
        key: :defense,
        name: "囲い",
        scope_block: -> av { av.find_all { |e| Bioshogi::Explain::DefenseInfo[e[:tag_name]] } },
      },
      {
        key: :attack_and_defense,
        name: "戦型＋囲い",
        scope_block: -> av { av.find_all { |e| Bioshogi::Explain::AttackInfo[e[:tag_name]] || Bioshogi::Explain::DefenseInfo[e[:tag_name]] } },
      },
      {
        key: :right_king,
        name: "右玉",
        scope_block: -> av { av.find_all { |e| e[:tag_name].match?(/右玉|清野流岐阜戦法/) } },
      },
      {
        key: :technique,
        name: "手筋",
        scope_block: -> av { av.find_all { |e| Bioshogi::Explain::TechniqueInfo[e[:tag_name]] } },
      },
      {
        key: :note,
        name: "備考",
        scope_block: -> av { av.find_all { |e| Bioshogi::Explain::NoteInfo[e[:tag_name]] } },
        # el_message: "異なるグループが混在しているため全体での比較には意味がない。たとえば居飛車と入玉を比べても意味がない。居飛車なら振り飛車と比べる。",
      },
      {
        key: :all,
        name: "全体",
        scope_block: -> av { av },
      },
    ]

    def ancestor_info
      Bioshogi::Explain::ScopeInfo.fetch(key)
    end

    def tag_table
      "#{key}_tags"
    end
  end
end
