class CpuStrategyInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "オールラウンド", },
    { key: "矢倉",           },
    { key: "右四間飛車",     },
    { key: "嬉野流",         },
    { key: "アヒル戦法",     },
    { key: "振り飛車",       },
  ]

  def self.fetch_by_params(params)
    key = params[:cpu_strategy_key]

    if key == "オールラウンド"
      rest = values - [self["オールラウンド"]]
      n = Integer(params[:cpu_strategy_random_number])
      pos = n.modulo(rest.size)
      return rest.at(pos)
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
