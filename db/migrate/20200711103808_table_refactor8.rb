class TableRefactor8 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_rooms do |t|
      t.belongs_to :bot_membership, foreign_key: {to_table: :actb_room_memberships}, null: true, comment: "練習相手"
    end
  end
end
