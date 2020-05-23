module Actb
  class Xsetting < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User"

    before_validation do
      self.game_key ||= GameInfo.fetch(:game_key1).key
    end

    with_options presence: true do
      validates :game_key
    end

    with_options allow_blank: true do
      validates :game_key, inclusion: GameInfo.keys.collect(&:to_s)
    end

    def game_info
      GameInfo.fetch(game_key)
    end
  end
end
