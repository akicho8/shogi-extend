class CpuStrategyInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "オールラウンダー", },
    { key: "居飛車",           },
    { key: "振り飛車",         },
  ]

  def self.fetch_by_params(params)
    if params[:cpu_strategy_key] == "オールラウンダー"
      list = values - [self["オールラウンダー"]]
      i = Integer(params[:all_round_seed]).modulo(list.size)
      list[i]
    else
      fetch(params[:cpu_strategy_key])
    end
  end

  def score_table
    @score_table ||= eval(File.read("#{__dir__}/cpu_strategy_info/#{key}.rb"))
  end
end
