class CustomEvaluator < Bioshogi::Evaluator::Level3
  private

  def opening_basic_table
    @opening_basic_table ||= cpu_strategy_info.score_table
  end

  def cpu_strategy_info
    @cpu_strategy_info ||= CpuStrategyInfo[params[:cpu_strategy_key]]
  end
end
