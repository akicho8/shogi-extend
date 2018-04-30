module ResourceNs1
  module ChatRooms
    class KifuValidsController < ApplicationController
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
            # records = brain.iterative_deepening(time_limit: 3, depth_range: 0..8)
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
            chat_room.update!(kifu_body_sfen: kifu_body_sfen, turn_max: mediator.turn_info.turn_max)
            # chat_room.update!(kifu_body_sfen: kifu_body_sfen) FIXME: turn_max も記録する

            render json: {
              # turn_info: {
              #   turn_max: mediator.turn_info.turn_max,
              #   current_location_key: mediator.turn_info.current_location.key,
              # }
              turn_max: mediator.turn_info.turn_max,
              kifu_body_sfen: kifu_body_sfen,
              human_kifu_text: ki2_a.join(" "),
              last_hand: ki2_a.last,
              without_self: true,
            }
            return
          end
        end
      end
    end
  end
end
