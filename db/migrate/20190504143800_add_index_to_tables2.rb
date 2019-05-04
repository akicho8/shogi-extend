class AddIndexToTables2 < ActiveRecord::Migration[5.2]
  def change
    [:swars_battles, :free_battles, :general_battles].each do |table|
      change_table table do |t|
        t.remove_index [:key, :battled_at]
      end
    end
  end
end
