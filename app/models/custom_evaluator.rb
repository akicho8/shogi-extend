class CustomEvaluator < Bioshogi::Evaluator::Level4
  private

  def opening_basic_table
    @opening_basic_table ||= cpu_strategy_info.score_table
  end

  def cpu_strategy_info
    @cpu_strategy_info ||= CpuStrategyInfo[params[:cpu_strategy_key]]
  end

  # 駒落ちがわかっている場合は↓にしたい
  # def pressure
  #   @pressure ||= players.inject({}) { |a, e| a.merge(e => 1.0) }
  # end
end
