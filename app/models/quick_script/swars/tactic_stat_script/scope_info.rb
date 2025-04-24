class QuickScript::Swars::TacticStatScript
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :attack,
        name: "戦法",
        target_infos: Bioshogi::Analysis::AttackInfo,
      },
      {
        key: :defense,
        name: "囲い",
        target_infos: Bioshogi::Analysis::DefenseInfo,
      },
      {
        key: :attack_and_defense,
        name: "戦法＋囲い",
        target_infos: Bioshogi::Analysis::AttackInfo.values + Bioshogi::Analysis::DefenseInfo.values,
      },
      {
        key: :right_king,
        name: "右玉",
        target_infos: Bioshogi::Analysis::AttackInfo.find_all { |e| e.group_info && e.group_info.key == :"右玉" },
      },
      {
        key: :technique,
        name: "手筋",
        target_infos: Bioshogi::Analysis::TechniqueInfo,
      },
      {
        key: :note,
        name: "備考",
        target_infos: Bioshogi::Analysis::NoteInfo,
      },
      {
        key: :all,
        name: "全体",
        target_infos: Bioshogi::Analysis::TacticInfo.all_elements,
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
