module Wkbk
  class AnswerKindInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :correct, name: "正解",   mark: "O", },
      { key: :mistake, name: "不正解", mark: "X", },
    ]
  end
end
