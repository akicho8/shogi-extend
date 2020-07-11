class TableRefactor2 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_room_memberships do |t|
      # t.string :session_lock_token, null: true, comment: "user_idよりもユニークな値"
    end
  end
end
