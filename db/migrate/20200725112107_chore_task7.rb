class ChoreTask7 < ActiveRecord::Migration[6.0]
  def up
    change_table :actb_notifications do |t|
      t.rename :to_user_id, :user_id
    end
  end
end
