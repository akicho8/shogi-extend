class FixShareBoard8 < ActiveRecord::Migration[5.1]
  def up
    change_column_null :share_board_battles, :win_location_id, true
  end
end
