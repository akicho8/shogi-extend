class QuickScript::Swars::TacticStatScript
  class ScopeInfo
    include ApplicationMemoryRecord
    memory_record [
      {
        key: :attack,
        name: "戦法",
        items: Bioshogi::Analysis::AttackInfo,
      },
      {
        key: :defense,
        name: "囲い",
        items: Bioshogi::Analysis::DefenseInfo,
      },
      {
        key: :attack_and_defense,
        name: "戦法＋囲い",
        items: Bioshogi::Analysis::AttackInfo.values + Bioshogi::Analysis::DefenseInfo.values,
      },
      {
        key: :right_king,
        name: "右玉",
        items: Bioshogi::Analysis::AttackInfo.find_all { |e| e.group_info && e.group_info.key == :"右玉" },
      },
      {
        key: :technique,
        name: "手筋",
        items: Bioshogi::Analysis::TechniqueInfo,
      },
      {
        key: :note,
        name: "備考",
        items: Bioshogi::Analysis::NoteInfo,
      },
      {
        key: :all,
        name: "全体",
        items: Bioshogi::Analysis::TagIndex.values,
      },
    ]

    def items_set
      @items_set ||= items.collect(&:key).to_set
    end
  end
end
