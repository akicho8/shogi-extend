module Wbook
  class SkillInfo
    MAX     = 100               # になったら次の段へ
    DEFAULT = "C-"              # 初期値

    include ApplicationMemoryRecord
    memory_record [
      { key: "C-",  win:  20.00, lose: 10.00, }, # 勝ったら +20 負けたら -10 なので上がりやすい
      { key: "C",   win:  19.00, lose: 10.00, },
      { key: "C+",  win:  18.00, lose: 10.00, },
      { key: "B-",  win:  17.00, lose: 10.00, },
      { key: "B",   win:  16.00, lose: 10.00, },
      { key: "B+",  win:  15.00, lose: 10.00, },
      { key: "A-",  win:  10.00, lose: 10.00, },
      { key: "A",   win:  10.00, lose: 10.00, },
      { key: "A+",  win:  10.00, lose: 10.00, },
      { key: "S",   win:   5.00, lose:  6.00, },
      { key: "S+",  win:   4.50, lose:  7.00, },
      { key: "S+1", win:   4.00, lose:  8.00, },
      { key: "S+2", win:   3.50, lose:  9.00, },
      { key: "S+3", win:   3.00, lose: 10.00, },
      { key: "S+4", win:   2.50, lose: 11.00, },
      { key: "S+5", win:   2.00, lose: 12.00, },
      { key: "S+6", win:   1.50, lose: 13.00, },
      { key: "S+7", win:   1.00, lose: 14.00, },
      { key: "S+8", win:   0.50, lose: 15.00, },
      { key: "S+9", win:   0.25, lose: 16.00, },
      { key: "X",   win:   0.10, lose: 17.00, },
    ]
  end
end
