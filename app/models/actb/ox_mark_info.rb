module Actb
  class OxMarkInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "correct", name: "正解",   score: 1,  sound_key: :pipopipo, delay_second: 1, },
      { key: "mistake", name: "不正解", score: -1, sound_key: :bubuu,    delay_second: 1, },
    ]
  end
end
