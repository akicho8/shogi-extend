module Wkbk
  class LobbyMessageBroadcastJob < ApplicationJob
    queue_as :default

    def perform(message)
      ActionCable.server.broadcast("wkbk/lobby_channel", bc_action: :lobby_speak_broadcasted, bc_params: {message: render_message(message)})
    end

    private

    def render_message(message)
      message.as_json_type8
    end
  end
end
