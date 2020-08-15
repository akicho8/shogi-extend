module Actb
  # rails r "tp Actb::EmotionInfo.as_json"
  # rails r "puts Actb::EmotionInfo.to_json"
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      # { category_key: :question, name: "🥺",   message: "🥺",       voice: "ぴえん",                 },
      # { category_key: :question, name: "❗❓", message: "❗❓",     voice: "",                       },
      # { category_key: :question, name: "🍣",   message: "🍣",       voice: "どーぞ",                 },
      # { category_key: :question, name: "簡",   message: "かんたん", voice: "かんたん",               },
      # { category_key: :question, name: "🍰",   message: "🍰",       voice: "どーぞ",                 },
      # { category_key: :question, name: "❓",   message: "❓",       voice: "わからん",               },
      { category_key: :question, name: "👍",   message: "👍",       voice: "すごい！",               },
      { category_key: :question, name: "💯",   message: "💯",       voice: "100点",                  },
      { category_key: :question, name: "❗",   message: "❗",       voice: "びっくり",               },
      { category_key: :question, name: "難",   message: "むずい",   voice: "むずい",                 },
      { category_key: :question, name: "よ",   message: "対よろ",   voice: "よろしく",               },
      { category_key: :question, name: "あ",   message: "対あり",   voice: "ありがとうございました", },

      { category_key: :versus,   name: "僥",   message: "僥倖です",               voice: "僥倖です",               },
      { category_key: :versus,   name: "お",   message: "おまえはもう詰んでいる", voice: "おまえはもう詰んでいる", },
      { category_key: :versus,   name: "な",   message: "なんだと!?",             voice: "なんだと!?",             },
      { category_key: :versus,   name: "た",   message: "ただやん",               voice: "ただやん",               },
      { category_key: :versus,   name: "や",   message: "やばい",                 voice: "やばい",                 },
      { category_key: :versus,   name: "よ",   message: "対よろ",                 voice: "よろしく",               },
      { category_key: :versus,   name: "あ",   message: "対あり",                 voice: "ありがとうございました", },
    ]
  end
end
