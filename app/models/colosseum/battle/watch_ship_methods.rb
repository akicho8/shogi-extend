module Colosseum::Battle::WatchShipMethods
  extend ActiveSupport::Concern

  included do
    has_many :watch_ships, dependent: :destroy                  # 観戦中の人たち(中間情報)
    has_many :watch_users, through: :watch_ships, source: :user # 観戦中の人たち
  end
end
