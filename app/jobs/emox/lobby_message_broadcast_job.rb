module Emox
  class LobbyMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("emox/lobby_channel", bc_action: :lobby_speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      message.as_json_type8
    end
  end
end
