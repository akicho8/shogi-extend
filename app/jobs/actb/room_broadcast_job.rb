module Actb
  class RoomBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room)
      room_json = room.as_json(only: [:id, :rule_key, :rensen_index], include: { memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:best_questions])
      if room.rensen_index == 0
        ActionCable.server.broadcast("actb/lobby_channel", bc_action: :room_broadcasted, bc_params: {room: room_json})
      else
        ActionCable.server.broadcast("actb/room_channel/#{room.parent.id}", bc_action: :saisen_room_broadcasted, bc_params: {room: room_json})
      end
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
    # end
  end
end
