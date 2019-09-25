module Colosseum::Battle::LobbyMethods
  extend ActiveSupport::Concern

  included do
    after_create_commit  { cud_broadcast(:create)  }
    after_update_commit  { cud_broadcast(:update)  }
    after_destroy_commit { cud_broadcast(:destroy) }
  end

  def cud_broadcast(action)
    ActionCable.server.broadcast("lobby_channel", battle_cud: {action: action, battle: ams_sr(self, serializer: Colosseum::BattleEachSerializer, include: {memberships: :user})})
  end
end
