module Fanta
  class WatchShip < ApplicationRecord
    belongs_to :battle, counter_cache: true
    belongs_to :user

    after_commit do
      # 観戦者が入室/退出した瞬間にチャットルームに反映する
      ActionCable.server.broadcast("battle_channel_#{battle.id}", watch_users: battle.watch_users)
    end
  end
end
