module Actb
  class RoomBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room)
      ActionCable.server.broadcast("actb/lobby_channel", bc_action: :room_broadcasted, bc_params: {room: room.as_json_type4})
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
    # end
  end
end
