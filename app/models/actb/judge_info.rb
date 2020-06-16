module Actb
  class JudgeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win,     name: "勝ち",     flip_key: :lose, sign_value: +1   },
      { key: :lose,    name: "負け",     flip_key: :win,  sign_value: -1   },
      { key: :draw,    name: "引き分け", flip_key: nil,   sign_value: nil, },
      { key: :pending, name: "未決定",   flip_key: nil,   sign_value: nil, },
    ]

    def flip
      self.class.fetch(flip_key || key)
    end
  end
end
