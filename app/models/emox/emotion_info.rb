module Emox
  # rails r "tp Emox::EmotionInfo.as_json"
  # rails r "puts Emox::EmotionInfo.to_json"
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      # { folder_key: :question, name: "🥺",   message: "🥺",       voice: "ぴえん",                 },
      # { folder_key: :question, name: "❗❓", message: "❗❓",     voice: "",                       },
      # { folder_key: :question, name: "🍣",   message: "🍣",       voice: "どーぞ",                 },
      # { folder_key: :question, name: "簡",   message: "かんたん", voice: "かんたん",               },
      # { folder_key: :question, name: "🍰",   message: "🍰",       voice: "どーぞ",                 },
      # { folder_key: :question, name: "❓",   message: "❓",       voice: "わからん",               },
      # { folder_key: :question, name: "👍",   message: "👍",       voice: "すごい！",               },
      # { folder_key: :question, name: "💯",   message: "💯",       voice: "100点",                  },
      # { folder_key: :question, name: "❗",   message: "❗",       voice: "びっくり",               },
      # { folder_key: :question, name: "難",   message: "むずい",   voice: "むずい",                 },
      # { folder_key: :question, name: "よ",   message: "対よろ",   voice: "よろしく",               },
      # { folder_key: :question, name: "あ",   message: "対あり",   voice: "ありがとうございました", },

      { name: "お",   message: "おまえはもう詰んでいる", voice: "おまえはもう詰んでいる", },
      { name: "な",   message: "なんだと!?",             voice: "なんだと!?",             },
      { name: "た",   message: "ただやん",               voice: "ただやん",               },
      { name: "や",   message: "やばい",                 voice: "やばい",                 },
      { name: "よ",   message: "対よろ",                 voice: "よろしく",               },
      { name: "あ",   message: "対あり",                 voice: "ありがとうございました", },
    ]
  end
end
