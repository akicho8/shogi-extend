class CreateSwarsFinals < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_finals rescue nil
    remove_column :swars_battles, :final_id rescue nil

    create_table :swars_finals, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Final.reset_column_information
    Swars::Final.setup

    change_table :swars_battles do |t|
      t.belongs_to :final, null: true, comment: "結末"
    end
  end
end
