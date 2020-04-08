class StandardDeviation
  attr_reader :values

  def initialize(values)
    @values = values.dup.freeze
  end

  # 標準偏差
  def sd
    @sd ||= -> {
      v = values.collect { |v| (v - avg) ** 2 }
      v = v.sum
      v = v.fdiv(values.size)
      Math.sqrt(v)
    }.call
  end

  # 平均
  def avg
    @avg ||= values.sum.fdiv(values.size)
  end

  # 合計
  def sum
    @sum ||= values.sum
  end

  # score の偏差値
  def deviation_value(score, sign = 1)
    ((score - avg) / sd) * (10 * sign) + 50
  end

  # 出現率
  def appear_ratio(score)
    score.fdiv(sum)
  end
end
