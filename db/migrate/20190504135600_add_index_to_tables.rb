class AddIndexToTables < ActiveRecord::Migration[5.2]
  def change
    change_table :swars_battles do |t|
      t.index [:key, :battled_at], unique: true
      t.index :battled_at
      t.index :turn_max
    end
    change_table :free_battles do |t|
      t.index [:key, :battled_at], unique: true
      t.index :battled_at
      t.index :turn_max
    end
    change_table :general_battles do |t|
      t.index [:key, :battled_at], unique: true
      t.index :battled_at
      t.index :turn_max
    end
  end
end
