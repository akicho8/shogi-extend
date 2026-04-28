class FixShareBoard9 < ActiveRecord::Migration[5.1]
  def up
    change_table :share_board_roomships do |t|
      t.integer :draw_count, null: false, index: false, comment: "引分数", default: 0
    end

    ShareBoard::Membership.find_each(&:zadd_call)
    ShareBoard::Roomship.find_each(&:save!)
    ShareBoard::Room.find_each(&:redis_rebuild)

    change_column_default(:share_board_roomships, :draw_count, nil)
  end

  def down
    remove_column :share_board_roomships, :draw_count
  end
end
