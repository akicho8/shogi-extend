class BattleRecord < ApplicationRecord
  has_many :battle_ships, dependent: :destroy
  has_many :battle_users, through: :battle_ships

  before_validation do
    self.unique_key ||= SecureRandom.hex
    if game_type_key
      self.game_type_key = GameTypeInfo.fetch(game_type_key).key
    end
    true
  end

  with_options presence: true do
    validates :unique_key
    validates :battle_key
    validates :game_type_key
    validates :csa_hands
  end

  with_options allow_blank: true do
    validates :battle_key, uniqueness: true
  end

  def to_param
    battle_key
  end

  def game_type_info
    GameTypeInfo.fetch_if(game_type_key)
  end
end
