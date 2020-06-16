module Actb
  class UdemaeInfo
    MAX     = 100               # になったら次の段へ
    DEFAULT = "C-"              # 初期値

    include ApplicationMemoryRecord
    memory_record [
      { key: "C-",  win: 20, lose: 10, }, # 勝ったら +20 負けたら -10 なので上がりやすい
      { key: "C",   win: 15, lose: 10, },
      { key: "C+",  win: 12, lose: 10, },
      { key: "B-",  win: 10, lose: 10, },
      { key: "B",   win: 10, lose: 10, },
      { key: "B+",  win: 10, lose: 10, },
      { key: "A-",  win: 10, lose: 10, },
      { key: "A",   win: 10, lose: 10, },
      { key: "A+",  win: 10, lose: 10, },
      { key: "S",   win:  5, lose:  6, },
      { key: "S+",  win:  4, lose:  7, },
      { key: "S+1", win:  4, lose:  7, },
      { key: "S+2", win:  4, lose:  7, },
      { key: "S+3", win:  4, lose:  7, },
      { key: "S+4", win:  4, lose:  7, },
      { key: "S+5", win:  4, lose:  7, },
      { key: "S+6", win:  4, lose:  7, },
      { key: "S+7", win:  4, lose:  7, },
      { key: "S+8", win:  4, lose:  7, },
      { key: "S+9", win:  4, lose:  7, },
      { key: "X",   win:  4, lose:  7, },
    ]
  end
end
