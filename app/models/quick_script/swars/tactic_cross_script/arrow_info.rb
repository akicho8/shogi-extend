class QuickScript::Swars::TacticCrossScript
  class ArrowInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :left_to_right, name: "→", el_message: "左から右", behavior: :reverse, },
      { key: :right_to_left, name: "←", el_message: "右から左", behavior: :itself,  },
    ]
  end
end
