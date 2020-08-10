class ChoreTask12 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_histories do |t|
      t.remove :room_id
      t.remove :battle_id
      t.remove :membership_id
      t.remove :rating
    end
  end
end
