module Acns2
  class LobbyBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room)
      room_json = room.as_json(only: [:id], include: { memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:simple_quest_infos])
      ActionCable.server.broadcast("acns2/lobby_channel", room: room_json)
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'acns2/messages/message', locals: { message: message })
    # end
  end
end
