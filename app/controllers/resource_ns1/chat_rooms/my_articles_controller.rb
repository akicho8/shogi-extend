module ResourceNs1
  module ChatRooms
    class MyArticlesController < ApplicationController
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

            # puts mediator
            # brain = mediator.current_player.brain(diver_class: Warabi::NegaScoutDiver, evaluator_class: Warabi::EvaluatorAdvance)
            # records = brain.interactive_deepning(time_limit: 3, depth_range: 0..8)
            # tp Warabi::Brain.human_format(records)
            # record = records.first
            # hand = record[:hand]
            # mediator.execute(hand.to_sfen, executor_class: Warabi::PlayerExecutorCpu)
            # # puts mediator.to_sfen
            # sfen = mediator.to_sfen
            #
            # logger.debug(info.to_sfen)

            kifu_body_sfen = mediator.to_sfen
            ki2_a = mediator.to_ki2_a

            chat_room = ChatRoom.find(params[:chat_room_id])
            chat_room.update!(kifu_body_sfen: kifu_body_sfen)

            render json: {kifu_body_sfen: kifu_body_sfen, ki2_a_block: ki2_a.join(" "), last_hand: ki2_a.last}
            return
          end
        end
      end
    end
  end
end
