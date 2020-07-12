class TableRefactor6 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_rooms do |t|
      t.boolean :practice, null: true, comment: "練習バトル？"
    end
  end
end
