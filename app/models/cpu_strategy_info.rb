class CpuStrategyInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: "居飛車",   },
    # { key: "振り飛車", },
  ]

  def score_table
    @score_table ||= eval(File.read("#{__dir__}/cpu_strategy_info/#{key}.rb"))
  end
end
