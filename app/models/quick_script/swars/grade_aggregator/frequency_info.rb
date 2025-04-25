class QuickScript::Swars::GradeAggregator
  class FrequencyInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :user,       name: "人数",   scope_chain: -> s { s.joins(:grade).select(:user_id, "swars_grades.key").distinct }, },
      { key: :membership, name: "対局数", scope_chain: -> s { s }, },
    ]
  end
end
