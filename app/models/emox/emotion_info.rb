module Emox
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      { name: "な",   message: "なんだと！？", voice: "なんだと！？",  },
      { name: "や",   message: "やばいよー",   voice: "やばいよー",    },
      { name: "こ",   message: "こうかな",     voice: "こうかな",      },
      { name: "難",   message: "むずい",       voice: "むずい",        },
      { name: "ど",   message: "どうしよう",   voice: "どうしよう",    },
      { name: "し",   message: "しょうがない", voice: "しょうがない",  },
      { name: "い",   message: "いいぞ",       voice: "いいぞ",        },
      { name: "る",   message: "やるじゃん",   voice: "やるじゃん",    },
      { name: "た",   message: "ただやん",     voice: "ただやん",      },
    ]
  end
end
