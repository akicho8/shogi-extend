module Actb
  class Judge < ApplicationRecord
    include StaticArModel

    scope :win_or_lose, -> { where(key: [:win, :lose]) }

    has_many :battle_memberships, dependent: :destroy

    def flip
      self.class.fetch(static_info.flip.key)
    end

    def win_or_lose?
      ["win", "lose"].include?(key)
    end
  end
end
