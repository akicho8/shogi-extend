class ChoreTask23 < ActiveRecord::Migration[5.1]
  def change
    change_table :free_battles do |t|
      t.remove :saturn_key
    end
  end
end
