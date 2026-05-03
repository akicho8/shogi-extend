class FixShareBoard11 < ActiveRecord::Migration[6.0]
  def up
    change_table :share_board_roomships do |t|
      t.rename :battles_count, :win_rate_denominator
    end

    ShareBoard::Membership.find_each(&:zadd_call)
    ShareBoard::Roomship.find_each(&:save!)
    ShareBoard::Room.find_each(&:redis_rebuild)
  end
end
