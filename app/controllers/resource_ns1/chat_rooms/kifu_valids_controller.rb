module ResourceNs1
  module ChatRooms
    class KifuValidsController < ApplicationController
      # def create
      #   if request.format.json?
      #     if v = params[:kifu_body]
      #       info = Warabi::Parser.parse(v)
      #       begin
      #         mediator = info.mediator
      #       rescue => error
      #         render json: {error_message: error.message}
      #         return
      #       end
      # 
      #       kifu_body_sfen = mediator.to_sfen
      #       ki2_a = mediator.to_ki2_a
      # 
      #       current_chat_room.clock_counts[mediator.opponent_player.location.key].push(params[:think_counter].to_i) # push でも AR は INSERT 対象になる
      #       current_chat_room.kifu_body_sfen = kifu_body_sfen
      #       current_chat_room.turn_max = mediator.turn_info.turn_max
      #       current_chat_room.save!
      # 
      #       render json: {
      #         turn_max: mediator.turn_info.turn_max,
      #         kifu_body_sfen: kifu_body_sfen,
      #         human_kifu_text: info.to_ki2, # or ki2_a.join(" ")
      #         last_hand: ki2_a.last,
      #         moved_chat_user_id: current_chat_user.id, # 操作した人(この人以外に盤面を反映する)
      #         clock_counts: current_chat_room.clock_counts,
      #       }
      #       return
      #     end
      #   end
      # end
      # 
      # private
      # 
      # def current_chat_room
      #   @current_chat_room ||= ChatRoom.find(params[:chat_room_id])
      # end
    end
  end
end
