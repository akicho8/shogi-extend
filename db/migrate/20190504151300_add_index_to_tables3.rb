class AddIndexToTables3 < ActiveRecord::Migration[5.2]
  def change
    change_table :swars_users do |t|
      t.index :last_reception_at
      t.index :updated_at
    end
  end
end
