class QuickScript::Swars::GradeStatScript
  class PopulationInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :user,       name: "人数",   unit: "人", },
      { key: :membership, name: "対局数", unit: "件", },
    ]
  end
end
