class AddTitleColumnToShareBoardRoom < ActiveRecord::Migration[5.1]
  def up
    # remove_column :share_board_rooms, :name rescue nil
    # remove_column :share_board_rooms, :title rescue nil
    change_table :share_board_rooms do |t|
      t.string :name, null: false, comment: "部屋名"
    end
  end
end
