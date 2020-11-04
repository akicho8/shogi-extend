module Emox
  class OxMarkInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :correct, name: "正解",     score: 1,  sound_key: :correct, delay_second: 0.7, question_counter_column: :o_count, },
      { key: :mistake, name: "不正解",   score: -1, sound_key: :mistake, delay_second: 0.5, question_counter_column: :x_count, },
      { key: :timeout, name: "時間切れ", score: 0,  sound_key: :timeout, delay_second: 0.7, question_counter_column: :x_count, },
    ]
  end
end
