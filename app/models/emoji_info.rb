class EmojiInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "動画",     real_string: "📽", },
    { key: "コメント", real_string: "📝", },
    { key: "棋譜ZIP",  real_string: "📗", },
  ]

  def to_s
    real_string
  end
end
