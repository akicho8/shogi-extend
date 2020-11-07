module Emox
  class BattleBroadcastJob < ApplicationJob
    queue_as :default

    def perform(battle)
      ActionCable.server.broadcast("emox/room_channel/#{battle.room.id}", bc_action: :battle_broadcasted, bc_params: {battle: battle.as_json_type1})
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'emox/messages/message', locals: { message: message })
    # end
  end
end
