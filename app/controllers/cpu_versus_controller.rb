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
        brain = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver, evaluator_class: Warabi::EvaluatorAdvance, legal_moves_only: false)
        records = []
        time_limit = 3
        begin
          records = brain.interactive_deepning(time_limit: time_limit, depth_max_range: 0..8)
        rescue Warabi::BrainHandsEmpty
          time_limit += 1
          retry
        end
        tp Warabi::Brain.human_format(records)

        if records.empty?
          render json: {toryo_message: "指し手がないので負けました(T_T)"}
          return
        end

        record = records.first
        if record[:score] <= -Warabi::INF_MAX
          render json: {toryo_message: "負けました(T_T)"}
          return
        end

        hand = record[:hand]
        mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)
        # puts mediator.to_sfen
        sfen = mediator.to_sfen

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
