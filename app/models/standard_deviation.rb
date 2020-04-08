# 標準偏差が欲しいとき用
#
#  sdc = StandardDeviation.new([1, 2, 3])
#  sdc.sd                 # => 0.816496580927726
#  sdc.avg                # => 2.0
#  sdc.sum                # => 6
#  sdc.deviation_score(2) # => 50.0
#  sdc.appear_ratio(2)    # => 0.3333333333333333
#
class StandardDeviation
  attr_reader :collection

  def initialize(collection)
    @collection = collection.dup.freeze
  end

  # 標準偏差
  def sd
    @sd ||= -> {
      v = collection.collect { |v| (v - avg)**2 }
      v = v.sum
      v = v.fdiv(collection.size)
      Math.sqrt(v)
    }.call
  end

  # 平均
  def avg
    @avg ||= sum.fdiv(collection.size)
  end

  # 合計
  def sum
    @sum ||= collection.sum
  end

  # 中央50基準の score の偏差値
  def deviation_score(score, sign = 1)
    ((score - avg) / sd) * (10 * sign) + 50
  end

  # 出現率
  def appear_ratio(score)
    score.fdiv(sum)
  end
end
