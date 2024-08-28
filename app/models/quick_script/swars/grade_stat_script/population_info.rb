class QuickScript::Swars::GradeStatScript
  class PopulationInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :user,       name: "人数",   },
      { key: :membership, name: "対局数", },
    ]
  end
end
