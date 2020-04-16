module Acns2
  class JudgeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :win,  name: "勝ち" },
      { key: :lose, name: "負け" },
    ]

    def flip
      
      self.class.fetch(key == :win ? :lose : :win)
    end
  end
end
