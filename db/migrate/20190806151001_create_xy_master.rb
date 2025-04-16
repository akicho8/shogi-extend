class CreateXyMaster < ActiveRecord::Migration[5.1]
  def change
    create_table :xy_master_time_records, force: true do |t|
      t.belongs_to :user,    null: true
      t.belongs_to :rule, null: false, comment: "ルール"
      t.string :entry_name,  null: false, index: true
      t.string :summary,     null: true
      t.integer :x_count,    null: false
      t.float :spent_sec,    null: false
      t.timestamps           null: false
    end
    create_table :xy_master_rules, force: true do |t|
      t.string :key, null: false
      t.integer :position, null: false, index: true
      t.timestamps
    end
  end
end
