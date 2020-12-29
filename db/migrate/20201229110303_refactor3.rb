class Refactor3 < ActiveRecord::Migration[6.0]
  def change
    create_table :xy_master_rules, force: true do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end
  end
end
