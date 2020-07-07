module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    def subscribed
      return reject unless room_code
      stream_from "share_board/room_channel/#{room_code}"
    end

    def sfen_share(data)
      broadcast(:sfen_share_broadcasted, data)
    end

    def title_share(data)
      broadcast(:title_share_broadcasted, data)
    end

    def room_code
      params["room_code"].presence
    end

    def broadcast(bc_action, bc_params)
      raise ArgumentError, bc_params.inspect unless bc_params.values.all?
      ActionCable.server.broadcast("share_board/room_channel/#{room_code}", {bc_action: bc_action, bc_params: bc_params})
    end
  end
end
