module Colosseum::Battle::UserMethods
  extend ActiveSupport::Concern

  included do
    has_many :memberships, dependent: :restrict_with_exception
    has_many :users, through: :memberships
  end

  def active_user
    user_by_turn(turn_max)
  end

  private

  def robot_player?
    active_user.race_info.key == :robot
  end

  def turn_info
    Bioshogi::TurnInfo.new(handicap: handicap, turn_offset: turn_max)
  end

  def user_by_turn(turn)
    index = turn_info.turn_offset_zero_location.code + turn # turn=0 のとき駒落ちなら index=1 になる
    position = index.modulo(memberships.size)
    memberships.find_by(position: position).user
  end
end
