module Actb
  class LobbyMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("actb/lobby_channel", bc_action: :lobby_speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      message.as_json(only: [:body], include: {user: {only: [:id, :key, :name], methods: [:avatar_path]}})
    end
  end
end
