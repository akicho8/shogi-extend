module Emox
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
# 508188b43f (akicho8 2020-11-04  7)       # { folder_key: :question, name: "🥺",   message: "🥺",       voice: "ぴえん",                 },
# 508188b43f (akicho8 2020-11-04  8)       # { folder_key: :question, name: "❗❓", message: "❗❓",     voice: "",                       },
# 508188b43f (akicho8 2020-11-04  9)       # { folder_key: :question, name: "🍣",   message: "🍣",       voice: "どーぞ",                 },
# 508188b43f (akicho8 2020-11-04 10)       # { folder_key: :question, name: "簡",   message: "かんたん", voice: "かんたん",               },
# 508188b43f (akicho8 2020-11-04 11)       # { folder_key: :question, name: "🍰",   message: "🍰",       voice: "どーぞ",                 },
# 508188b43f (akicho8 2020-11-04 12)       # { folder_key: :question, name: "❓",   message: "❓",       voice: "わからん",               },
# 508188b43f (akicho8 2020-11-04 13)       { folder_key: :question, name: "👍",   message: "👍",       voice: "すごい！",               },
# 508188b43f (akicho8 2020-11-04 14)       { folder_key: :question, name: "💯",   message: "💯",       voice: "100点",                  },
# 508188b43f (akicho8 2020-11-04 15)       { folder_key: :question, name: "❗",   message: "❗",       voice: "びっくり",               },
# 508188b43f (akicho8 2020-11-04 16)       { folder_key: :question, name: "難",   message: "むずい",   voice: "むずい",                 },
# 508188b43f (akicho8 2020-11-04 17)       { folder_key: :question, name: "よ",   message: "対よろ",   voice: "よろしく",               },
# 508188b43f (akicho8 2020-11-04 18)       { folder_key: :question, name: "あ",   message: "対あり",   voice: "ありがとうございました", },

      { name: "こ",   message: "こうかな",     voice: "こうかな",      },
      { name: "る",   message: "やるじゃん",   voice: "やるじゃん",    },
      { name: "な",   message: "なんだと！？", voice: "なんだと！？",  },
      { name: "難",   message: "むずい",       voice: "むずい",        },
      { name: "や",   message: "やばいよー",   voice: "やばいよー",    },
      { name: "ど",   message: "どうしよう",   voice: "どうしよう",    },
      { name: "し",   message: "しょうがない", voice: "しょうがない",  },
      { name: "い",   message: "いいぞ",       voice: "いいぞ",        },
      { name: "た",   message: "ただやん",     voice: "ただやん",      },
    ]
  end
end
