module Actb
  class BattleBroadcastJob < ApplicationJob
    queue_as :default

    def perform(battle)
      battle_json = battle.as_json(only: [:id, :rule_key, :rensen_index], include: { memberships: { only: [:id], include: {user: { only: [:id, :name], methods: [:avatar_path] }} } }, methods: [:best_questions])
      if battle.rensen_index == 0
        ActionCable.server.broadcast("actb/lobby_channel", bc_action: :battle_broadcasted, bc_params: {battle: battle_json})
      else
        ActionCable.server.broadcast("actb/battle_channel/#{battle.parent.id}", bc_action: :saisen_battle_broadcasted, bc_params: {battle: battle_json})
      end
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
    # end
  end
end
