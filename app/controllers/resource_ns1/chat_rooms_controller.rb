module ResourceNs1
  class ChatRoomsController < ApplicationController
    def show
      unless ChatRoom.exists?
        ChatRoom.create!
      end

      @chat_room_app_params = {
        path: url_for([:resource_ns1, :chat_rooms, format: "json"]),
        current_chat_user: current_chat_user,
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

          sfen = mediator.to_sfen

          render json: {sfen: sfen}
          return
        end
      end
    end

    def current_chat_user
      @current_chat_user ||= ChatUser.find_by(id: cookies.signed[:chat_user_id])
      unless @current_chat_user
        @current_chat_user = ChatUser.create!(name: "#{ChatUser.count.next}さん")
        cookies.signed[:chat_user_id] = @current_chat_user.id
      end
      @current_chat_user
    end

    helper_method :current_chat_user
  end
end
