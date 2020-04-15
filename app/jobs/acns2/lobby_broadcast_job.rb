module Acns2
  class LobbyBroadcastJob < ApplicationJob
    queue_as :default

    def perform(room)
      json = room.as_json(root: true, only: [:id], include: { memberships: { only: [:id], include: {user: { only: [:id, :name] }} } })
      ActionCable.server.broadcast("acns2/lobby_channel", json)
    end

    # private
    # 
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'acns2/messages/message', locals: { message: message })
    # end
  end
end
