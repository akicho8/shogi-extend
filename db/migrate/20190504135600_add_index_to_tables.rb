class AddIndexToTables < ActiveRecord::Migration[5.2]
  def change
    [:swars_battles, :free_battles, :general_battles].each do |table|
      change_table table do |t|
        t.index [:key, :battled_at], unique: true
        t.index :battled_at
        t.index :turn_max
      end
    end
  end
end
