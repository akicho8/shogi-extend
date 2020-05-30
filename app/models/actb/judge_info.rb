module Actb
  class JudgeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win,     name: "勝ち",     flip_key: :lose, },
      { key: :lose,    name: "負け",     flip_key: :win,  },
      { key: :draw,    name: "引き分け", flip_key: nil,   },
      { key: :pending, name: "未決定",   flip_key: nil,   },
    ]

    def flip
      self.class.fetch(flip_key || key)
    end
  end
end
