module Actb
  class BattleBroadcastJob < ApplicationJob
    queue_as :default

    def perform(battle)
      battle_json = battle.as_json(only: [:id, :rensen_index], include: { rule: { only: [:key, :name] }, final: { only: [:key, :name], methods: [:lose_side] }, room: {}, memberships: { only: [:id, :judge_key, :question_index], include: {user: { only: [:id, :name], methods: [:avatar_path, :rating], include: {actb_current_xrecord: { only: [:rensho_count, :renpai_count] } } }} } }, methods: [:best_questions]) # JSON1
      ActionCable.server.broadcast("actb/room_channel/#{battle.room.id}", bc_action: :battle_broadcasted, bc_params: {battle: battle_json})
    end

    # private
    #
    # def render_message(message)
    #   ApplicationController.renderer.render(partial: 'actb/messages/message', locals: { message: message })
    # end
  end
end
