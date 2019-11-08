class CustomEvaluator < Bioshogi::EvaluatorBase
  private

  def soldier_score(e)
    w = e.relative_weight

    keys = [e.piece.key, e.promoted]
    key = keys.join("_")
    x, y = e.normalized_place.to_xy

    if cpu_strategy_info = CpuStrategyInfo[params[:cpu_strategy_key]]
      if t = cpu_strategy_info.score_table[keys]
        w += t[y][x]
      end
    end

    v = Bioshogi::BoardAdvanceScore.fetch(key)
    s = v.weight_list[e.bottom_spaces]
    w += s

    w * e.location.value_sign
  end
end
