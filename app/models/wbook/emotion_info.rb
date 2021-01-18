module Wbook
  # rails r "tp Wbook::EmotionInfo.as_json"
  # rails r "puts Wbook::EmotionInfo.to_json"
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      # { folder_key: :question, name: "🥺",   message: "🥺",       voice: "ぴえん",                 },
      # { folder_key: :question, name: "❗❓", message: "❗❓",     voice: "",                       },
      # { folder_key: :question, name: "🍣",   message: "🍣",       voice: "どーぞ",                 },
      # { folder_key: :question, name: "簡",   message: "かんたん", voice: "かんたん",               },
      # { folder_key: :question, name: "🍰",   message: "🍰",       voice: "どーぞ",                 },
      # { folder_key: :question, name: "❓",   message: "❓",       voice: "わからん",               },
      { folder_key: :question, name: "👍",   message: "👍",       voice: "すごい！",               },
      { folder_key: :question, name: "💯",   message: "💯",       voice: "100点",                  },
      { folder_key: :question, name: "❗",   message: "❗",       voice: "びっくり",               },
      { folder_key: :question, name: "難",   message: "むずい",   voice: "むずい",                 },
      { folder_key: :question, name: "よ",   message: "対よろ",   voice: "よろしく",               },
      { folder_key: :question, name: "あ",   message: "対あり",   voice: "ありがとうございました", },

      { folder_key: :versus,   name: "お",   message: "おまえはもう詰んでいる", voice: "おまえはもう詰んでいる", },
      { folder_key: :versus,   name: "な",   message: "なんだと!?",             voice: "なんだと!?",             },
      { folder_key: :versus,   name: "た",   message: "ただやん",               voice: "ただやん",               },
      { folder_key: :versus,   name: "や",   message: "やばい",                 voice: "やばい",                 },
      { folder_key: :versus,   name: "よ",   message: "対よろ",                 voice: "よろしく",               },
      { folder_key: :versus,   name: "あ",   message: "対あり",                 voice: "ありがとうございました", },
    ]
  end
end
