class CpuVersusController < ApplicationController
  def show
    @cpu_versus_app_params = {
      player_mode_moved_path: url_for([:cpu_versus, format: "json"]),
    }
  end

  def create
    if request.format.json?
      if v = params[:kifu_body]
        info = Warabi::Parser.parse(v, typical_error_case: :embed)
        begin
          mediator = info.mediator
        rescue => error
          render json: {error_message: error.message}
          return
        end

        captured_soldier = mediator.opponent_player.executor.captured_soldier
        if captured_soldier
          if captured_soldier.piece.key == :king
            render json: {toryo_message: "玉を取られたので負けました"}
            return
          end
        end

        puts mediator
        brain = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver, evaluator_class: Warabi::EvaluatorAdvance)
        records = []
        time_limit = (params[:time_limit].presence || 3).to_i
        begin
          records = brain.iterative_deepening(time_limit: time_limit, depth_max_range: 1..5)
        rescue Warabi::BrainProcessingHeavy
          time_limit += 1
          p [:retry, {time_limit: time_limit}]
          retry
        end
        tp Warabi::Brain.human_format(records)

        if records.empty?
          render json: {toryo_message: "もう指す手がありません。負けました(T_T)"}
          return
        end

        record = records.first
        if record[:score] <= -Warabi::INF_MAX
          render json: {toryo_message: "降参です。負けました(T_T)"}
          return
        end

        hand = record[:hand]
        mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)
        # puts mediator.to_sfen
        sfen = mediator.to_sfen

        if true
          # 人間側の手がなければ人間側のまけ
          brain = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver, evaluator_class: Warabi::EvaluatorAdvance)
          if brain.lazy_all_hands.none? { |e| e.regal_move?(mediator) }
            render json: {toryo_message: "CPUの勝ちです"}
            return
          end
        end

        retval = {sfen: sfen}

        captured_soldier = mediator.opponent_player.executor.captured_soldier
        if captured_soldier
          if captured_soldier.piece.key == :king
            retval.update(toryo_message: "CPUの勝ちです")
          end
        end

        logger.debug(info.to_sfen)
        render json: retval
        return
      end
    end
  end
end
