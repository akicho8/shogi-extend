class CustomEvaluator < Bioshogi::EvaluatorBase
  private

  def soldier_score(e)
    w = e.relative_weight

    cpu_strategy_info = CpuStrategyInfo[params[:cpu_strategy_key]]

    # Rails.logger.debug(params)

    # keys = [e.piece.key, e.promoted]
    # key = keys.join("_")

    # 成ったときはすべて0点なので計算しない
    # テーブルには成ったとき情報は持たない
    if cpu_strategy_info
      if !e.promoted
        score_table = cpu_strategy_info.score_table
        if t = score_table[:field][e.piece.key]
          x, y = e.normalized_place.to_xy
          s = t[y][x]
          if Rails.env.development?
            if s.nonzero?
              Rails.logger.info([cpu_strategy_info.name, e.piece, s])
            end
          end
          w += s
        end
        if t = score_table[:advance][e.piece.key]
          s = t[e.bottom_spaces]
          w += s
        end
      end
    end

    # v = Bioshogi::BoardAdvanceScore.fetch(key)
    # s = v.weight_list[e.bottom_spaces]
    # w += s

    w * e.location.value_sign
  end
end
