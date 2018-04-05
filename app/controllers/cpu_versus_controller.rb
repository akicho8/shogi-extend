class CpuVersusController < ApplicationController
  def show
    @cpu_versus_app_params = {
      path: url_for([:cpu_versus, format: "json"]),
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

        puts mediator
        records = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver).interactive_deepning(time_limit: 3, depth_max_range: 0..8)
        tp Warabi::Brain.human_format(records)
        record = records.first
        hand = record[:hand]
        mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)
        # puts mediator.to_sfen
        sfen = mediator.to_sfen

        logger.debug(info.to_sfen)
        render json: {sfen: sfen}
        return
      end
    end
  end
end
