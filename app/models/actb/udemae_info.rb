module Actb
  class UdemaeInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "C-", win: 20, lose: 10, },
      { key: "C",  win: 15, lose: 10, },
      { key: "C+", win: 12, lose: 10, },
      { key: "B-", win: 10, lose: 10, },
      { key: "B",  win: 10, lose: 10, },
      { key: "B+", win: 10, lose: 10, },
      { key: "A-", win: 10, lose: 10, },
      { key: "A",  win: 10, lose: 10, },
      { key: "A+", win: 10, lose: 10, },
      { key: "S",  win:  5, lose:  6, },
      { key: "S+", win:  4, lose:  4, },
    ]
  end
end
