# 未使用
module Actb
  class UdemaeInfo
    include ApplicationMemoryRecord
    # https://wikiwiki.jp/splatoon2mix/%E6%A4%9C%E8%A8%BC/%E3%82%A6%E3%83%87%E3%83%9E%E3%82%A8
    memory_record [
      { key: "C-",  power: 1000, },
      { key: "C",   power: 1100, }, # 100
      { key: "C+",  power: 1200, }, # 100
      { key: "B-",  power: 1250, }, # 50
      { key: "B",   power: 1450, }, # 200
      { key: "B+",  power: 1550, }, # 100
      { key: "A-",  power: 1650, }, # 100
      { key: "A",   power: 1700, }, # 50
      { key: "A+",  power: 1800, }, # 100
      { key: "S",   power: 1900, }, # 100
      { key: "S+0", power: 2000, }, # 100
      { key: "S+1", power: 2080, }, # 80
      { key: "S+2", power: 2120, }, # 40
      { key: "S+3", power: 2160, }, # 40
      { key: "S+4", power: 2200, }, # 40
      { key: "S+5", power: 2230, }, # 30
      { key: "S+6", power: 2260, }, # 30
      { key: "S+7", power: 2290, }, # 30
      { key: "S+8", power: 2320, }, # 30
      { key: "S+9", power: 2350, }, # 30
    ]
  end
end
