class CpuStrategyInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "オールラウンド", },
    { key: "矢倉",           },
    { key: "右四間飛車",     },
    { key: "嬉野流",         },
    { key: "アヒル",         },
    { key: "振り飛車",       },
    { key: "かまいたち",     },
  ]

  def self.values_without_all_round
    @values_without_all_round ||= values - [self["オールラウンド"]]
  end

  def self.fetch_by_params(params)
    key = params[:cpu_strategy_key]

    if key == "オールラウンド"
      n = Integer(params[:cpu_strategy_random_number])
      pos = n.modulo(values_without_all_round.size)
      return values_without_all_round.at(pos)
    end

    fetch(key)
  end

  def score_table
    @score_table ||= eval(source_file.read, binding, source_file.to_s)
  end

  private

  def source_file
    Pathname("#{__dir__}/#{self.class.name.underscore}/#{key}.rb")
  end
end
