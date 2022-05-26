class CreateSwarsRules < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_rules rescue nil
    remove_column :swars_battles, :rule_id rescue nil

    create_table :swars_rules, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Rule.reset_column_information
    Swars::Rule.setup

    change_table :swars_battles do |t|
      t.belongs_to :rule, null: true, comment: "持ち時間"
    end
  end
end
