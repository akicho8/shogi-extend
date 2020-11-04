module Emox
  class EmotionInfo
    include ApplicationMemoryRecord
    memory_record [
      { name: "お",   message: "おまえはもう詰んでいる", voice: "おまえはもう詰んでいる", },
      { name: "な",   message: "なんだと!?",             voice: "なんだと!?",             },
      { name: "た",   message: "ただやん",               voice: "ただやん",               },
      { name: "や",   message: "やばい",                 voice: "やばい",                 },
      { name: "よ",   message: "対よろ",                 voice: "よろしく",               },
      { name: "あ",   message: "対あり",                 voice: "ありがとうございました", },
    ]
  end
end
