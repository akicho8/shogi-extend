module Actb
  class RoomBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room)
      room_json = room.as_json(only: [:id], include: { memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [])
      ActionCable.server.broadcast("actb/lobby_channel", bc_action: :room_broadcasted, bc_params: {room: room_json})
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
    # end
  end
end
