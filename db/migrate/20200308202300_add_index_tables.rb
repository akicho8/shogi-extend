class AddIndexTables < ActiveRecord::Migration[5.2]
  def change
    change_table :swars_battles do |t|
      t.index :outbreak_turn
      t.change :accessed_at, :datetime, null: false
    end
    change_table :free_battles do |t|
      t.index :outbreak_turn
      t.index :use_key
      t.change :accessed_at, :datetime, null: false
    end
  end
end
