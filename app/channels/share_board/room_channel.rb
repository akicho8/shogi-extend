module ShareBoard
  class RoomChannel < ApplicationCable::Channel
    def subscribed
      return reject unless room_code
      stream_from "share_board/room_channel/#{room_code}"
    end

    def sfen_share(data)
      data = data.to_options
      bc_params = {
        user_code: data[:user_code],
        sfen:      data[:sfen],
        title:     data[:title],
      }
      broadcast(:sfen_share_broadcasted, bc_params)
    end

    def title_share(data)
      data = data.to_options
      bc_params = {
        user_code: data[:user_code],
        title: data[:title],
      }
      broadcast(:title_share_broadcasted, bc_params)
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
