module Emox
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      { name: "つ",   message: "詰んでる",   voice: "詰んでる",    },
      { name: "な",   message: "なんだと!?", voice: "なんだと!?",  },
      { name: "た",   message: "ただやん",   voice: "ただやん",    },
      { name: "や",   message: "やばい",     voice: "やばい",      },
      { name: "よ",   message: "対よろ",     voice: "たいよろ",    },
      { name: "あ",   message: "対あり",     voice: "たいあり",    },
    ]
  end
end
