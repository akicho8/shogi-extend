module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    def subscribed
      return reject unless room_code
      stream_from "share_board/room_channel/#{room_code}"
    end

    def sfen_share(data)
      SlackAgent.message_send(key: "共有将棋盤使用中(#{data["from_user_name"]})", body: data.inspect)
      broadcast(:sfen_share_broadcasted, data)
    end

    def title_share(data)
      broadcast(:title_share_broadcasted, data)
    end

    def board_info_request(data)
      broadcast(:board_info_request_broadcasted, data)
    end

    def board_info_send(data)
      broadcast(:board_info_send_broadcasted, data)
    end

    def chess_clock_share(data)
      broadcast(:chess_clock_share_broadcasted, data)
    end

    def member_info_share(data)
      broadcast(:member_info_share_broadcasted, data)
    end

    def room_code
      params["room_code"].presence
    end

    def broadcast(bc_action, bc_params)
      if v = bc_params.find_all { |k, v| v.nil? }.presence
        raise ArgumentError, "値が nil のキーがある : #{v.to_h.inspect}"
      end
      ActionCable.server.broadcast("share_board/room_channel/#{room_code}", {bc_action: bc_action, bc_params: bc_params})
    end
  end
end
