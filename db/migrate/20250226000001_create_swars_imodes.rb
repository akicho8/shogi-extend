class CreateSwarsImodes < ActiveRecord::Migration[5.1]
  def up
    drop_table :swars_xmode2s rescue nil
    remove_column :swars_battles, :xmode2_id rescue nil

    drop_table :swars_imodes rescue nil
    remove_column :swars_battles, :imode_id rescue nil

    create_table :swars_imodes, force: true do |t|
      t.string :key,       null: false, index: { unique: true }
      t.integer :position, null: true,  index: true, comment: "順序"
      t.timestamps         null: false
    end

    Swars::Imode.reset_column_information
    Swars::Imode.setup
    imode = Swars::Imode.fetch("通常")
    tp imode

    change_table :swars_battles do |t|
      t.belongs_to :imode, null: false, default: imode.id, comment: "開始局面"
    end

    Swars::Battle.reset_column_information
    Swars::Battle.update_all(imode_id: imode.id)
    change_column_null :swars_battles, :imode_id, false

    Swars::Battle.reset_column_information
  end
end
