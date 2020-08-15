module Actb
  # rails r "tp Actb::EmotionInfo.as_json"
  # rails r "puts Actb::EmotionInfo.to_json"
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      { category_key: :question, name: "🥺",   message: "🥺",       say: "ぴえん",                 },
      { category_key: :question, name: "❗❓", message: "❗❓",     say: "",                       },
      { category_key: :question, name: "🍣",   message: "🍣",       say: "どーぞ",                 },
      { category_key: :question, name: "簡",   message: "かんたん", say: "かんたん",               },
      { category_key: :question, name: "🍰",   message: "🍰",       say: "どーぞ",                 },
      { category_key: :question, name: "❓",   message: "❓",       say: "わからん",               },
      { category_key: :question, name: "難",   message: "むずい",   say: "むずい",                 },
      { category_key: :question, name: "👍",   message: "👍",       say: "すごい！",               },
      { category_key: :question, name: "💯",   message: "💯",       say: "100点",                  },
      { category_key: :question, name: "❗",   message: "❗",       say: "びっくり",               },
      { category_key: :question, name: "よ",   message: "対よろ",   say: "よろしく",               },
      { category_key: :question, name: "あ",   message: "対あり",   say: "ありがとうございました", },
      { category_key: :versus,   name: "び",   message: "びっくり", say: "びっくり",               },
      { category_key: :versus,   name: "た",   message: "ただやん", say: "ただやん",               },
      { category_key: :versus,   name: "や",   message: "やばい",   say: "やばい",                 },
      { category_key: :versus,   name: "よ",   message: "対よろ",   say: "よろしく",               },
      { category_key: :versus,   name: "あ",   message: "対あり",   say: "ありがとうございました", },
    ]
  end
end
