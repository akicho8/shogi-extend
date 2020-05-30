module Actb
  class BattleBroadcastJob < ApplicationJob
    queue_as :default

    def perform(battle)
      battle_json = battle.as_json(only: [:id, :rensen_index], include: { rule: { only: [:id, :key, :name] }, room: {}, memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:best_questions])
      ActionCable.server.broadcast("actb/room_channel/#{battle.room.id}", bc_action: :battle_broadcasted, bc_params: {battle: battle_json})
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
    # end
  end
end
