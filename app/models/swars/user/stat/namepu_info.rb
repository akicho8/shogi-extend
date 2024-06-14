# frozen-string-literal: true

module Swars
  module User::Stat
    class NamepuInfo
      include ApplicationMemoryRecord
      memory_record [
        { key: :"穴角戦法",       weight: 0.500, },
        { key: :"穴角向かい飛車", weight: 0.500, },
        { key: :"筋違い角",       weight: 0.080, },
        { key: :"新米長玉",       weight: 0.100, },
        { key: :"手損角交換型",   weight: 0.000, },
        { key: :"風車",           weight: 0.010, },
        { key: :"新風車",         weight: 0.010, },
        { key: :"アヒル戦法",     weight: 0.001, },
        { key: :"裏アヒル戦法",   weight: 0.001, },
      ]
    end
  end
end
