# 度数→偏差値変換
#
# av = [
#   { "度数" => 1 },
#   { "度数" => 2 },
#   { "度数" => 4 },
#   { "度数" => 2 },
#   { "度数" => 1 },
# ]
# tp StandardDeviation.call(av)
# # > |------+----------+---------------------+--------+---------------------+-------------------|
# # > | 度数 | 相対度数 | 累計相対度数        | 階級値 | 基準値              | 偏差値            |
# # > |------+----------+---------------------+--------+---------------------+-------------------|
# # > |    1 |      0.1 |                 0.1 |      0 |  1.7320508075688774 | 67.32050807568878 |
# # > |    2 |      0.2 | 0.30000000000000004 |     -1 |  0.8660254037844387 | 58.66025403784439 |
# # > |    4 |      0.4 |  0.7000000000000001 |     -2 |                 0.0 |              50.0 |
# # > |    2 |      0.2 |  0.9000000000000001 |     -3 | -0.8660254037844387 | 41.33974596215561 |
# # > |    1 |      0.1 |  1.0000000000000002 |     -4 | -1.7320508075688774 | 32.67949192431122 |
# # > |------+----------+---------------------+--------+---------------------+-------------------|
module StandardDeviation
  extend self

  def call(av)
    total_count = av.sum { |e| e["度数"] }
    av = av.collect { |e| e.merge("相対度数" => e["度数"].fdiv(total_count)) }
    t = 0; av = av.collect { |e| t += e["相対度数"]; e.merge("累計相対度数" => t) }
    av = av.collect.with_index { |e, i| e.merge("階級値" => -i) }
    score_total = av.sum { |e| e["度数"] * e["階級値"] }
    score_average = score_total.fdiv(total_count)
    variance = av.sum { |e| (e["階級値"] - score_average)**2 * e["度数"] } / total_count.pred
    standard_deviation = Math.sqrt(variance)
    av = av.collect { |e| e.merge("基準値" => (e["階級値"] - score_average).fdiv(standard_deviation)) }
    standard_value_average = av.sum { |e| e["基準値"] } / av.count
    av = av.collect { |e| e.merge("偏差値" => (e["基準値"] * 10 + 50)) }
  end
end
