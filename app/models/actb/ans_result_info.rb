module Actb
  class AnsResultInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "correct", name: "正解",   score: 1,  },
      { key: "mistake", name: "不正解", score: -1, },
    ]
  end
end
