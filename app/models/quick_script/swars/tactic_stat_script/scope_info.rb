class QuickScript::Swars::TacticStatScript
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :attack,
        name: "戦法",
        scope_block: -> av { av.find_all { |e| Bioshogi::Analysis::AttackInfo[e[:tag_name]] } },
      },
      {
        key: :defense,
        name: "囲い",
        scope_block: -> av { av.find_all { |e| Bioshogi::Analysis::DefenseInfo[e[:tag_name]] } },
      },
      {
        key: :attack_and_defense,
        name: "戦法＋囲い",
        scope_block: -> av { av.find_all { |e| Bioshogi::Analysis::AttackInfo[e[:tag_name]] || Bioshogi::Analysis::DefenseInfo[e[:tag_name]] } },
      },
      {
        key: :right_king,
        name: "右玉",
        scope_block: -> av { av.find_all { |e| Bioshogi::Analysis::AttackInfo[e[:tag_name]].try { group_info&.key == :"右玉" } } },
      },
      {
        key: :technique,
        name: "手筋",
        scope_block: -> av { av.find_all { |e| Bioshogi::Analysis::TechniqueInfo[e[:tag_name]] } },
      },
      {
        key: :note,
        name: "備考",
        scope_block: -> av { av.find_all { |e| Bioshogi::Analysis::NoteInfo[e[:tag_name]] } },
        # el_message: "異なるグループが混在しているため全体での比較には意味がない。たとえば居飛車と入玉を比べても意味がない。居飛車なら振り飛車と比べる。",
      },
      {
        key: :all,
        name: "全体",
        scope_block: -> av { av },
      },
    ]

    def ancestor_info
      Bioshogi::Analysis::ScopeInfo.fetch(key)
    end

    def tag_table
      "#{key}_tags"
    end
  end
end
